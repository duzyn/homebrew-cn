cask "brisk" do
  version "1.2.0"
  sha256 "1ad1da10a3bb2b31af88bc19b6f5b3a018de63e922f632fbdcd7a5e626b96601"

  url "https://mirror.ghproxy.com/https://github.com/br1sk/brisk/releases/download/#{version}/Brisk.app.tar.gz"
  name "Brisk"
  desc "App for submitting radars"
  homepage "https://github.com/br1sk/brisk"

  livecheck do
    url "https://mirror.ghproxy.com/https://raw.githubusercontent.com/br1sk/brisk/master/appcast.xml"
    strategy :sparkle
  end

  no_autobump! because: :requires_manual_review

  auto_updates true

  app "Brisk.app"

  zap trash: [
    "~/Library/Application Support/Blisk",
    "~/Library/Caches/Blisk",
    "~/Library/Preferences/org.blisk.Blisk.plist",
    "~/Library/Saved Application State/org.blisk.Blisk.savedState",
  ]

  caveats do
    requires_rosetta
  end
end
