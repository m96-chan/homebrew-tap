cask "ktapple" do
  version "1.0.0"
  sha256 "a3a942c166459226e0c1716265efe58f75fc9da33bedba7072cc8a36f79f94d4"

  url "https://github.com/m96-chan/KTApple/releases/download/v#{version}/KTApple-#{version}-arm64.dmg"
  name "KTApple"
  desc "KDE Plasma KWin-style tiling window manager for macOS"
  homepage "https://github.com/m96-chan/KTApple"

  depends_on macos: ">= :ventura"

  app "KTApple.app"

  zap trash: [
    "~/Library/Application Support/KTApple",
  ]
end
