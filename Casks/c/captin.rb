cask "captin" do
  version "1.3.1"
  sha256 :no_check

  url "https://mirror.ghproxy.com/https://raw.githubusercontent.com/cool8jay/public/master/captin/Captin.zip",
      verified: "mirror.ghproxy.com/https://raw.githubusercontent.com/cool8jay/public/master/captin/"
  name "Captin"
  desc "Tool to show caps lock status"
  homepage "https://captin.mystrikingly.com/"

  livecheck do
    url "https://mirror.ghproxy.com/https://raw.githubusercontent.com/cool8jay/public/master/captin/appcast.xml"
    strategy :sparkle, &:short_version
  end

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :high_sierra"

  app "Captin.app"

  uninstall quit: "com.100hps.captin"

  zap trash: [
    "~/Library/Caches/com.100hps.captin",
    "~/Library/Preferences/com.100hps.captin.plist",
  ]
end
