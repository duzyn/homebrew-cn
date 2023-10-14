cask "dat" do
  version "3.0.1"
  sha256 "f6c89150f72568c2de1f42653bca0fa356cbb24704f31f1ef5e11f75b0095866"

  url "https://ghproxy.com/https://github.com/dat-ecosystem-archive/dat-desktop/releases/download/v#{version}/dat-desktop-#{version}-mac.zip",
      verified: "github.com/dat-ecosystem-archive/dat-desktop/"
  name "Dat Desktop"
  desc "Peer to peer data sharing app built for humans"
  homepage "https://dat-ecosystem.org/"

  app "Dat Desktop.app"

  zap trash: [
    "~/Library/Application Support/Dat",
    "~/Library/Caches/com.datproject.dat",
    "~/Library/Caches/com.datproject.dat.ShipIt",
    "~/Library/Preferences/com.datproject.dat.helper.plist",
    "~/Library/Preferences/com.datproject.dat.plist",
    "~/Library/Saved Application State/com.datproject.dat.savedState",
    "~/.dat",
    "~/.dat-desktop",
  ]

  caveats do
    discontinued
  end
end