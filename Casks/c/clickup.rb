cask "clickup" do
  arch arm: "arm64", intel: "x64"

  version "3.4.9,240703ei2pbh2v9"
  sha256 arm:   "8eba62f0bd8bd906141f3686192af84be6f8850ed793a8641ac8617c7119543e",
         intel: "a03b5e6eca7bf51c9e56fab5fb4689a0673489da2c12ad7cdeaa15bfc666418f"

  url "https://download.todesktop.com/221003ra4tebclw/ClickUp%20#{version.csv.first}%20-%20Build%20#{version.csv.second}-#{arch}.dmg",
      verified: "download.todesktop.com/221003ra4tebclw/"
  name "ClickUp"
  desc "Productivity platform for tasks, docs, goals, and chat"
  homepage "https://clickup.com/"

  # NOTE: The magic string in the URL (e.g. `221003ra4tebclw`) may need to be
  # updated over time, as the existing URL may only return an old version.
  livecheck do
    url "https://download.todesktop.com/221003ra4tebclw/latest-mac.yml"
    regex(/ClickUp\s*v?(\d+(?:\.\d+)+).*?Build\s*([a-z0-9]+)[._-]#{arch}\.dmg/i)
    strategy :electron_builder do |yaml|
      yaml["files"]&.map do |item|
        match = item["url"]&.match(regex)
        next if match.blank?

        "#{match[1]},#{match[2]}"
      end
    end
  end

  depends_on macos: ">= :catalina"

  app "ClickUp.app"

  zap trash: [
    "~/Library/Application Support/ClickUp Desktop",
    "~/Library/Application Support/ClickUp",
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.clickup.desktop-app.sfl*",
    "~/Library/Caches/com.clickup.desktop-app",
    "~/Library/Caches/com.clickup.desktop-app.ShipIt",
    "~/Library/Logs/ClickUp",
    "~/Library/Preferences/com.clickup.desktop-app.plist",
    "~/Library/Saved Application State/com.clickup.desktop-app.savedState",
  ]
end
