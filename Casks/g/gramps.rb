cask "gramps" do
  arch arm: "Arm", intel: "Intel"

  version "6.0.1,1"
  sha256 arm:   "0f0307c6029623e784a25e95a95268ddc3f5edc9b1fd67ed3fd642298989ddde",
         intel: "21435864180b459575ffdb710be203071d6cba094ed2c0efff45c40d400c62c8"

  url "https://mirror.ghproxy.com/https://github.com/gramps-project/gramps/releases/download/v#{version.csv.first}/Gramps-#{arch}-#{version.csv.first}-#{version.csv.second}.dmg",
      verified: "github.com/gramps-project/gramps/"
  name "Gramps"
  desc "Genealogy software"
  homepage "https://gramps-project.org/blog/"

  livecheck do
    url :url
    regex(/^Gramps[._-]#{arch}[._-]v?(\d+(?:\.\d+)+)[._-](\d+)\.dmg$/i)
    strategy :github_releases do |json, regex|
      json.map do |release|
        next if release["draft"] || release["prerelease"]

        release["assets"]&.map do |asset|
          match = asset["name"]&.match(regex)
          next if match.blank?

          "#{match[1]},#{match[2]}"
        end
      end.flatten
    end
  end

  depends_on macos: ">= :high_sierra"

  app "Gramps.app"

  zap trash: [
    "~/Library/Application Support/gramps",
    "~/Library/Preferences/org.gramps-project.gramps.plist",
    "~/Library/Saved Application State/org.gramps-project.gramps.savedState",
  ]
end
