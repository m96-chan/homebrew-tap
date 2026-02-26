cask "ktapple" do
  version "1.1.0"
  sha256 "c2414918024eb16f04b3ccfedd85df71aa09dab5734ec413867514ba0d345b3e"

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
