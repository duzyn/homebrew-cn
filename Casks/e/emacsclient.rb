cask "emacsclient" do
  version "1.0"
  sha256 :no_check

  url "https://mirror.ghproxy.com/https://github.com/sprig/org-capture-extension/raw/master/EmacsClient.app.zip"
  name "emacsclient"
  desc "Chrome/Firefox extension that facilitates org-capture in emacs"
  homepage "https://github.com/sprig/org-capture-extension"

  livecheck do
    url :url
    strategy :extract_plist
  end

  app "EmacsClient.app"
end
