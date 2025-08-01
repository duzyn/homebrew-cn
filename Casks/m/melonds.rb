cask "melonds" do
  version "1.0"
  sha256 "f89c7083646a29d2b878b98ed4e842779705d5be00a3fffe23fca091657f21ab"

  url "https://mirror.ghproxy.com/https://github.com/melonDS-emu/melonDS/releases/download/#{version}/macOS-universal.zip",
      verified: "github.com/melonDS-emu/melonDS/"
  name "melonDS"
  desc "Nintendo DS and DSi emulator"
  homepage "https://melonds.kuribo64.net/"

  no_autobump! because: :requires_manual_review

  app "melonDS.app"

  zap trash: "~/Library/Preferences/melonDS/melonDS.ini"
end
