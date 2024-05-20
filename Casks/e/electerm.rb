cask "electerm" do
  arch arm: "arm64", intel: "x64"

  version "1.39.18"
  sha256 arm:   "06d5051eb2357509cf9194359db8d5d5d7e519436cc96b599284c86b275992b7",
         intel: "dd41184b86438e816805b668f323f0ab774ca7e3e86ffa648f2df855cbd5cdb4"

  url "https://mirror.ghproxy.com/https://github.com/electerm/electerm/releases/download/v#{version}/electerm-#{version}-mac-#{arch}.dmg"
  name "electerm"
  desc "Terminal/ssh/sftp client"
  homepage "https://github.com/electerm/electerm/"

  auto_updates true

  app "electerm.app"
  binary "#{appdir}/electerm.app/Contents/MacOS/electerm"

  zap trash: [
    "~/Library/Application Support/electerm",
    "~/Library/Logs/electerm",
    "~/Library/Preferences/org.electerm.electerm.plist",
    "~/Library/Saved Application State/org.electerm.electerm.savedState",
  ]
end
