cask "sdm" do
  version "21.87.0,E2619C57ADBF007BDCD53676112FA2062C6662F5"
  sha256 "ba63ac7d9ae929b86742b5a943a800b7efa324baf8204be75227fdbb3550ca6d"

  url "https://downloads.strongdm.com/builds/desktop/#{version.csv.first}/darwin-universal/#{version.csv.second}/SDM-#{version.csv.first}.universal.zip"
  name "sdm"
  desc "StrongDM client"
  homepage "https://www.strongdm.com/"

  livecheck do
    url "https://app.strongdm.com/releases/desktop/darwin/0.0.0"
    regex(%r{https:.*?/(\h+)/SDM[._-]v?(\d+(?:\.\d+)+)\.universal\.zip}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| "#{match[1]},#{match[0]}" }
    end
  end

  depends_on macos: ">= :high_sierra"

  app "SDM.app"
  binary "#{appdir}/SDM.app/Contents/Resources/sdm.darwin", target: "sdm"

  uninstall delete: "#{appdir}/SDM.app/Contents/Resources/sdm-socket"

  zap trash: [
    "/usr/local/bin/sdm",
    "~/.sdm",
    "~/Library/Application Support/SDM",
    "~/Library/Caches/com.electron.sdm*",
    "~/Library/Preferences/com.electron.sdm.plist",
    "~/Library/Saved Application State/com.electron.sdm.savedState",
  ]
end
