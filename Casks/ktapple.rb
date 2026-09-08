cask "ktapple" do
  version "2.0.0"
  sha256 "edc93450e29b844090b0b6bfa138922882be6a8b86b613514e0bb513c80e27ce"

  url "https://github.com/m96-chan/KTApple/releases/download/v#{version}/KTApple-#{version}-arm64.dmg"
  name "KTApple"
  desc "KDE Plasma KWin-style tiling window manager for macOS"
  homepage "https://github.com/m96-chan/KTApple"

  depends_on macos: ">= :sequoia"

  app "KTApple.app"

  zap trash: [
    "~/Library/Application Support/KTApple",
  ]
end
