cask "memo" do
  version "1.0.3"
  sha256 :no_check

  url "https://usememo.com/MemoSetup.dmg"
  name "Memo"
  desc "Note taking app using GitHub Gists"
  homepage "https://usememo.com/"

  livecheck do
    url "https://ghproxy.com/raw.githubusercontent.com/btk/memo/master/package.json"
    strategy :page_match do |page|
      JSON.parse(page)["version"]
    end
  end

  app "Memo.app"

  zap trash: [
    "~/Library/Application Support/Memo",
    "~/Library/Preferences/com.usememo.app.plist",
    "~/Library/Saved Application State/com.usememo.app.savedState",
  ]
end
