cask "webpquicklook" do
  version "1.0"
  sha256 :no_check

  url "https://ghproxy.com/https://raw.githubusercontent.com/emin/WebPQuickLook/master/WebpQuickLook.tar.gz",
      verified: "ghproxy.com/https://raw.githubusercontent.com/emin/WebPQuickLook/"
  name "WebPQuickLook"
  desc "QuickLook plugin for webp files"
  homepage "https://github.com/emin/WebPQuickLook"

  livecheck do
    url :url
    strategy :extract_plist
  end

  qlplugin "WebpQuickLook.qlgenerator"

  # No zap stanza required
end
