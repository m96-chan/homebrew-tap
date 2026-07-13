cask "virtualcamera4mac" do
  version "0.0.5"
  sha256 "eaf3ff81865fcd3bc89e075cb3d6aa539a90aa4071bc49a3595de49ac56090f5"

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
