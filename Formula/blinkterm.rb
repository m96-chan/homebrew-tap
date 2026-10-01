# The canonical copy of the Homebrew formula. The one in the tap
# (https://github.com/m96-chan/homebrew-tap, Formula/blinkterm.rb) is a copy
# of this file: a change is made here, built by .github/workflows/homebrew.yml
# before it is merged, and copied over on a release (RELEASING.md, "Homebrew").
class Blinkterm < Formula
  desc "Real browser in a terminal: headless Chromium over the Kitty graphics protocol"
  homepage "https://github.com/m96-chan/blinkterm"
  # GitHub's archive of the tag; RELEASING.md ("Homebrew") says how both lines
  # are made on each release. `head` stays below, so `--HEAD` keeps installing
  # main.
  url "https://github.com/m96-chan/blinkterm/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "39ff09ddf2596fc843ec98bd5e108a8a038f081dd144054a34a7e7cb52494832"
  license "MIT"
  head "https://github.com/m96-chan/blinkterm.git", branch: "main"

  # Build dependencies before platform requirements: that is the order
  # `brew audit --strict` checks components in, and it refuses the other.
  depends_on "rust" => :build

  # No platform requirement: v0.2.0 is the first release that runs on macOS
  # (ci.yml's `mac` job runs the engine tests on macos-15), and
  # homebrew.yml builds this formula there as well as on Linux.

  def install
    # std_cargo_args is `--jobs N --locked --root=#{prefix} --path=.`.
    # --locked, so the build is the tree CI tested. cargo fetches libc from
    # crates.io during the build; Homebrew allows a build network access unless a formula says otherwise,
    # under Linux's Landlock sandbox as on macOS, and this one does not.
    system "cargo", "install", *std_cargo_args
  end

  def caveats
    <<~EOS
      blinkterm does not ship a browser engine, but

        blinkterm --install-engine

      fetches the one it is tested against. It looks at $BLINKTERM_ENGINE
      first, then for that one, then on PATH for chrome-headless-shell, chromium, chromium-browser,
      google-chrome and chromium-shell, in that order. The one it is tested
      against is chrome-headless-shell from Chrome for Testing:

        https://googlechromelabs.github.io/chrome-for-testing/

      Unzip the linux64 chrome-headless-shell build somewhere and point at it:

        export BLINKTERM_ENGINE=/opt/chrome-headless-shell-linux64/chrome-headless-shell

      On a Mac with Apple silicon, the same version's mac-arm64 build:

        export BLINKTERM_ENGINE=~/engine/chrome-headless-shell-mac-arm64/chrome-headless-shell

      A Google Chrome or Chromium in /Applications is found without that.

      docs/install.md in the repository has the exact download and the
      libraries it wants. Debian's chromium-shell package is Chromium's
      content_shell, not a headless shell: it keeps a DevTools port open beside
      the pipe and does not close when asked, so a profile is never flushed.
      It is last on the list for that reason.

      A terminal that speaks the Kitty graphics protocol, the Kitty keyboard
      protocol and SGR mouse reporting is needed: Kitty, WezTerm, Ghostty or a
      tOS pane.
    EOS
  end

  test do
    # Neither needs an engine or a terminal: --version and --help are answered
    # before either is looked for. A regex rather than `version.to_s`, which is
    # "HEAD" under --HEAD.
    assert_match(/^blinkterm \d+\.\d+\.\d+/, shell_output("#{bin}/blinkterm --version"))
    assert_match "--profile", shell_output("#{bin}/blinkterm --help")
  end
end
