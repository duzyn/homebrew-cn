cask "stella" do
  version "6.7.1"
  sha256 "9a03faf300719b652c06118262b890712a52ff035d67470648b40a853f8a6e1e"

  url "https://mirror.ghproxy.com/https://github.com/stella-emu/stella/releases/download/#{version}/Stella-#{version}-macos.dmg",
      verified: "github.com/stella-emu/stella/"
  name "Stella"
  desc "Multi-platform Atari 2600 Emulator"
  homepage "https://stella-emu.github.io/"

  depends_on macos: ">= :high_sierra"

  app "Stella.app"

  zap trash: "~/Library/Application Support/Stella"
end
