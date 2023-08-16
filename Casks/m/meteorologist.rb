cask "meteorologist" do
  version "4.0.1"
  sha256 "f9c9e7ee1cade25b3848f5de78e879ce240552fdaafd165a34df15312fef3fd5"

  url "https://downloads.sourceforge.net/heat-meteo/Meteorologist-#{version}.dmg?use_mirror=nchc",
      verified: "downloads.sourceforge.net/heat-meteo/?use_mirror=nchc"
  name "Meteorologist"
  desc "Adjustable weather viewing application"
  homepage "https://heat-meteo.sourceforge.io/"

  app "Meteorologist.app"

  zap trash: [
    "~/Library/Caches/com.heat.Meteorologist",
    "~/Library/Logs/Meteorologist.log",
    "~/Library/Preferences/com.heat.Meteorologist.plist",
  ]
end
