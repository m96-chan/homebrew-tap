cask "ktapple" do
  version "1.2.0"
  sha256 "6af38ac23fe9e282dd35014122f1a98a86b6ddf2608910df52cadce204a1c7fc"

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
