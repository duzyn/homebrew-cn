cask "tabtab" do
  version "1.3.3"
  sha256 :no_check

  url "https://mirror.ghproxy.com/https://github.com/riccqi/TabTabApp/releases/download/prod/tabtab.dmg",
      verified: "github.com/riccqi/TabTabApp/"
  name "TabTab"
  desc "Window and tab manager"
  homepage "https://tabtabapp.net/"

  livecheck do
    url "https://mirror.ghproxy.com/https://raw.githubusercontent.com/riccqi/TabTabApp/refs/heads/main/appcast.xml"
    strategy :sparkle, &:short_version
  end

  depends_on macos: ">= :sonoma"

  app "TabTab.app"

  zap trash: [
    "~/Library/Caches/riccqi.TabTab",
    "~/Library/HTTPStorages/riccqi.TabTab",
    "~/Library/Preferences/riccqi.TabTab.plist",
  ]
end
