cask "praat" do
  version "6.4.19,6419"
  sha256 "7fbf117bc958ba28202d05dd0c8c42a5a6a29bfa4136c2df21a80d2fccd770d9"

  url "https://mirror.ghproxy.com/https://github.com/praat/praat/releases/download/v#{version.csv.first}/praat#{version.csv.second}_mac.dmg",
      verified: "github.com/praat/praat/"
  name "Praat"
  desc "Doing phonetics by computer"
  homepage "https://www.fon.hum.uva.nl/praat/"

  livecheck do
    url :url
    regex(%r{/v?(\d+(?:\.\d+)+)/praat(\d+)[._-]mac\.dmg$}i)
    strategy :github_latest do |json, regex|
      json["assets"]&.map do |asset|
        match = asset["browser_download_url"]&.match(regex)
        next if match.blank?

        "#{match[1]},#{match[2]}"
      end
    end
  end

  app "Praat.app"
  binary "#{appdir}/Praat.app/Contents/MacOS/Praat", target: "praat"

  zap trash: [
    "~/Library/Preferences/Praat Prefs",
    "~/Library/Saved Application State/org.praat.Praat.savedState",
  ]
end
