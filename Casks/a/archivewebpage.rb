cask "archivewebpage" do
  version "0.12.8"
  sha256 "7d9e4337f4e2b3bc6b1200ee1041fcf57b2517fb3f09908a473c3ebff1cb6a73"

  url "https://mirror.ghproxy.com/https://mirror.ghproxy.com/https://github.com/webrecorder/archiveweb.page/releases/download/v#{version}/ArchiveWeb.page-#{version}.dmg",
      verified: "mirror.ghproxy.com/https://github.com/webrecorder/archiveweb.page/"
  name "ArchiveWeb.page"
  desc "Archive webpages manually to WARC or WACZ files as you browse the web"
  homepage "https://archiveweb.page/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :catalina"

  app "ArchiveWeb.page.app"

  zap trash: [
    "~/Library/Application Support/ArchiveWeb.page",
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/net.webrecorder.archivewebpage.sfl*",
    "~/Library/Caches/net.webrecorder.archivewebpage",
    "~/Library/Caches/net.webrecorder.archivewebpage.ShipIt",
    "~/Library/HTTPStorages/net.webrecorder.archivewebpage",
    "~/Library/Logs/ArchiveWeb.page",
    "~/Library/Preferences/net.webrecorder.archivewebpage.plst",
    "~/Library/Saved Application State/net.webrecorder.archivewebpage.savedState",
  ]
end
