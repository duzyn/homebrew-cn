cask "shield" do
  version "1.2"
  sha256 "fa0162763caaf7e9bd2bbeae5a43ccd8193fdf9885f183590d1612479b267487"

  url "https://mirror.ghproxy.com/https://github.com/theevilbit/Shield/releases/download/#{version}/Shield.app_#{version}.zip",
      verified: "github.com/theevilbit/Shield/"
  name "Shield"
  desc "App to protect against process injection"
  homepage "https://theevilbit.github.io/shield/"

  livecheck do
    url :url
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :catalina"

  app "Shield.app"

  zap trash: "/Library/Application Support/Shield/com.csaba.fitzl.shield.preferences.plist"
end
