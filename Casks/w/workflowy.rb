cask "workflowy" do
  version "4.0.2411261507"
  sha256 "9b30208fed662a554324d2ecffdcd57c3f792401adf1946d1beae52e6edbdf9e"

  url "https://mirror.ghproxy.com/https://github.com/workflowy/desktop/releases/download/v#{version}/WorkFlowy.zip",
      verified: "github.com/workflowy/desktop/"
  name "WorkFlowy"
  desc "Notetaking tool"
  homepage "https://workflowy.com/downloads/mac/"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true

  app "WorkFlowy.app"

  zap trash: [
    "~/Library/Application Support/WorkFlowy",
    "~/Library/Preferences/com.workflowy.desktop.plist",
    "~/Library/Saved Application State/com.workflowy.desktop.savedState",
  ]
end
