cask "ente" do
  version "1.7.12"
  sha256 "1674c7c155549a9198b85e2791671a66a89f038abe601524bb82c0687548ec0c"

  url "https://mirror.ghproxy.com/https://github.com/ente-io/photos-desktop/releases/download/v#{version}/ente-#{version}-universal.dmg",
      verified: "github.com/ente-io/photos-desktop/"
  name "Ente"
  desc "Desktop client for Ente Photos"
  homepage "https://ente.io/"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "ente.app"

  zap trash: [
    "~/Library/Application Support/ente",
    "~/Library/Logs/ente",
    "~/Library/Preferences/io.ente.bhari-frame.helper.plist",
    "~/Library/Preferences/io.ente.bhari-frame.plist",
    "~/Library/Saved Application State/io.ente.bhari-frame.savedState",
  ]
end
