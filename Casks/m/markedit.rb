cask "markedit" do
  version "1.20.0"
  sha256 "124100a218dadc4620c4350b0376d208e9faad6ad4de7ccce96f1c70eeaeef11"

  url "https://mirror.ghproxy.com/https://github.com/MarkEdit-app/MarkEdit/releases/download/v#{version}/MarkEdit-#{version}.dmg"
  name "MarkEdit"
  desc "Markdown editor"
  homepage "https://github.com/MarkEdit-app/MarkEdit"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :ventura"

  app "MarkEdit.app"

  zap trash: [
    "~/Library/Application Scripts/app.cyan.markedit",
    "~/Library/Application Scripts/app.cyan.markedit.preview-extension",
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/app.cyan.markedit.sfl*",
    "~/Library/Containers/app.cyan.markedit",
    "~/Library/Containers/app.cyan.markedit.preview-extension",
    "~/Library/Saved Application State/app.cyan.markedit.savedState",
  ]
end
