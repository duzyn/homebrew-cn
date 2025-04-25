cask "electerm" do
  arch arm: "arm64", intel: "x64"

  version "1.80.5"
  sha256 arm:   "8b73ca982896951b51ac75f92ab11167d17aeac6dcdba303079fce6b3ea3c34d",
         intel: "9ffdf7f3adf657015eba0589141ba77409667805b6ec8838b98a6ecb156c10da"

  url "https://mirror.ghproxy.com/https://github.com/electerm/electerm/releases/download/v#{version}/electerm-#{version}-mac-#{arch}.dmg"
  name "electerm"
  desc "Terminal/ssh/sftp client"
  homepage "https://github.com/electerm/electerm/"

  auto_updates true
  depends_on macos: ">= :catalina"

  app "electerm.app"
  binary "#{appdir}/electerm.app/Contents/MacOS/electerm"

  zap trash: [
    "~/Library/Application Support/electerm",
    "~/Library/Logs/electerm",
    "~/Library/Preferences/org.electerm.electerm.plist",
    "~/Library/Saved Application State/org.electerm.electerm.savedState",
  ]
end
