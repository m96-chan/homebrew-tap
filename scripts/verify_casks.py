#!/usr/bin/env python3
"""Verify every cask in this tap points at a genuine m96-chan release asset.

A tap is a supply-chain component: `brew install` runs whatever the cask
points at. This checks two things per cask, and fails the build otherwise:

  1. the download URL lives under an allowed GitHub owner, and
  2. the declared sha256 matches the bytes actually served at that URL.

A cask edited to point somewhere else, or with a hash that no longer matches
the asset, cannot reach main.
"""
import hashlib
import pathlib
import re
import sys
import urllib.request

ALLOWED_URL_PREFIXES = ("https://github.com/m96-chan/",)
CHUNK = 1 << 20


def field(text: str, name: str) -> str | None:
    m = re.search(rf'^\s*{name}\s+"([^"]+)"', text, re.MULTILINE)
    return m.group(1) if m else None


def sha256_of(url: str) -> str:
    h = hashlib.sha256()
    req = urllib.request.Request(url, headers={"User-Agent": "tap-verify"})
    with urllib.request.urlopen(req, timeout=120) as r:
        while chunk := r.read(CHUNK):
            h.update(chunk)
    return h.hexdigest()


def check(path: pathlib.Path) -> list[str]:
    text = path.read_text(encoding="utf-8")
    problems = []

    version = field(text, "version")
    declared = field(text, "sha256")
    url = field(text, "url")

    for label, value in (("version", version), ("sha256", declared), ("url", url)):
        if not value:
            problems.append(f"{path}: no {label} field found")
    if problems:
        return problems

    # Casks interpolate the version into the URL.
    url = url.replace("#{version}", version)

    if not url.startswith(ALLOWED_URL_PREFIXES):
        allowed = ", ".join(ALLOWED_URL_PREFIXES)
        problems.append(f"{path}: url is outside the allowed prefixes ({allowed}): {url}")
        return problems

    try:
        actual = sha256_of(url)
    except Exception as exc:  # noqa: BLE001 - report, don't crash the run
        problems.append(f"{path}: could not fetch {url}: {exc}")
        return problems

    if actual != declared:
        problems.append(
            f"{path}: sha256 mismatch for {url}\n"
            f"    declared: {declared}\n"
            f"    actual:   {actual}"
        )
    else:
        print(f"  ok  {path.name}  v{version}  {actual[:16]}…")

    return problems


def main() -> int:
    root = pathlib.Path(__file__).resolve().parent.parent
    casks = sorted(root.glob("Casks/*.rb")) + sorted(root.glob("Formula/*.rb")) + sorted(root.glob("*.rb"))
    if not casks:
        print("no casks or formulae found — nothing to verify")
        return 0

    print(f"verifying {len(casks)} file(s)")
    problems = [p for c in casks for p in check(c)]

    if problems:
        print("\nFAILED:", file=sys.stderr)
        for p in problems:
            print(f"  {p}", file=sys.stderr)
        return 1

    print("\nall casks verified")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
