cask "kdrive" do
  version "3.5.6.20240118"
  sha256 "15acb26713afbd1c2bf2aa2a61e3e860e576240df3bd59dad94c89ac20d347d1"

  url "https://download.storage.infomaniak.com/drive/desktopclient/kDrive-#{version}.pkg"
  name "kDrive"
  desc "Client for the kDrive collaborative cloud storage service"
  homepage "https://www.infomaniak.com/kdrive"

  livecheck do
    url "https://www.infomaniak.com/drive/latest"
    regex(/kDrive[._-](\d+(?:\.\d+)+)\.pkg/i)
    strategy :json do |json|
      json["macos"]["downloadurl"]&.scan(regex)&.map { |match| (match[0]).to_s }
    end
  end

  depends_on macos: ">= :catalina"

  pkg "kDrive-#{version}.pkg"

  uninstall_preflight do
    system_command "/usr/bin/pkill", args: ["-f", "/Applications/kDrive/kDrive.app"]
  end

  uninstall launchctl: "864VDCS2QY.com.infomaniak.drive.desktopclient.LoginItemAgent",
            quit:      [
              "com.infomaniak.drive.desktopclient",
              "com.infomaniak.drive.desktopclient.Extension",
            ],
            pkgutil:   [
              "com.infomaniak.drive.desktopclient",
              "com.infomaniak.drive.desktopclient.Extension",
              "com.infomaniak.drive.uninstaller",
            ],
            delete:    "/Applications/kDrive/kDrive Uninstaller.app",
            rmdir:     "/Applications/kDrive"

  zap trash: [
    "~/Library/Application Scripts/864VDCS2QY.com.infomaniak.drive.desktopclient.LoginItemAgent",
    "~/Library/Application Scripts/com.infomaniak.drive.desktopclient.Extension",
    "~/Library/Caches/com.infomaniak.drive.desktopclient",
    "~/Library/Containers/864VDCS2QY.com.infomaniak.drive.desktopclient.LoginItemAgent",
    "~/Library/Containers/com.infomaniak.drive.desktopclient.Extension",
    "~/Library/Cookies/com.infomaniak.drive.desktopclient.binarycookies",
    "~/Library/Group Containers/864VDCS2QY.com.infomaniak.drive.desktopclient",
    "~/Library/Preferences/com.infomaniak.drive.desktopclient.plist",
    "~/Library/Preferences/kDrive",
  ]
end
