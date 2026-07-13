cask "virtualcamera4mac" do
  version "0.0.6"
  sha256 "55040963f1d641ca746dc50696422c3cac1625c297438a60b9ac5c9c88efbdf2"

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
