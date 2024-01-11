cask "mailmaster" do
  version "4.17.24.1344"
  sha256 "850778e5b906a572a4c14078ff439a753dda6baf6fe1d925d0c2272047efa85e"

  url "http://fm.dl.126.net/mailmaster/updatemac/mailmaster-#{version}.dmg",
      verified: "fm.dl.126.net/mailmaster/"
  name "NetEase Mail Master"
  name "网易邮箱大师"
  desc "Email client"
  homepage "https://mail.163.com/dashi/"

  livecheck do
    url "http://fm.dl.126.net/mailmaster/updatemac/update_config.json"
    strategy :json do |json|
      json["targets"].map { |target| target["version"] }
    end
  end

  auto_updates true
  depends_on macos: ">= :el_capitan"

  app "MailMaster.app"

  uninstall quit: "com.netease.macmail"

  zap trash: [
    "~/Library/Application Scripts/com.netease.macmail",
    "~/Library/Application Scripts/com.netease.macmail-launcher",
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.netease.macmail-launcher.sfl*",
    "~/Library/Containers/com.netease.macmail",
    "~/Library/Containers/com.netease.macmail-launcher",
    "~/Library/Preferences/com.netease.macmail.plist",
    "~/Library/Saved Application State/com.netease.macmail.savedState",
  ]
end
