cask "spotmenu" do
  version "2.0.5"
  sha256 "2aab71ab15f60079b31705b6a493c3062e8c754c3f6d756abc3720fcf4fade49"

  url "https://mirror.ghproxy.com/https://github.com/kmikiy/SpotMenu/releases/download/v#{version}/SpotMenu.app.zip"
  name "SpotMenu"
  desc "Spotify and iTunes in the menu bar"
  homepage "https://github.com/kmikiy/SpotMenu"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :sonoma"

  app "SpotMenu.app"

  uninstall quit:       "com.github.kmikiy.SpotMenu",
            login_item: "SpotMenu"

  zap trash: [
    "~/Library/Application Scripts/com.github.kmikiy.SpotMenu",
    "~/Library/Application Support/com.github.kmikiy.SpotMenu",
    "~/Library/Group Containers/com.github.kmikiy.SpotMenu",
    "~/Library/Preferences/com.github.kmikiy.SpotMenu.plist",
  ]
end
