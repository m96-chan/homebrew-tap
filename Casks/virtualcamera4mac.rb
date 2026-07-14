cask "virtualcamera4mac" do
  version "0.0.7"
  sha256 "88846e42b6fdb96bd4b7d2a61a4b24d2600e413436d9c68c8ec8372d618126ee"

  url "https://github.com/m96-chan/VirtualCamera4Mac/releases/download/v#{version}/VirtualCamera4Mac-#{version}.dmg"
  name "VirtualCamera4Mac"
  desc "Virtual camera for macOS backed by a CoreMediaIO system extension"
  homepage "https://github.com/m96-chan/VirtualCamera4Mac"

  depends_on macos: ">= :ventura"

  app "VirtualCamera4Mac.app"

  uninstall quit: "io.github.m96chan.VirtualCamera4Mac"

  zap trash: [
    "~/Library/Application Support/VirtualCamera4Mac",
  ]
end
