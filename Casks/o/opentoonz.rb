cask "opentoonz" do
  version "1.7.1"
  sha256 "b2849f4359499164ee610c17e1a79019f5a3474fb37620243e4bd8c8724fc136"

  url "https://mirror.ghproxy.com/https://github.com/opentoonz/opentoonz/releases/download/v#{version}/OpenToonz.pkg",
      verified: "github.com/opentoonz/opentoonz/"
  name "OpenToonz"
  desc "Open-source full-featured 2D animation creation software"
  homepage "https://opentoonz.github.io/e/index.html"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  pkg "OpenToonz.pkg"

  uninstall pkgutil: "io.github.opentoonz"

  zap trash: [
    "~/Library/Caches/OpenToonz",
    "~/Library/Saved Application State/io.github.opentoonz.OpenToonz.savedState",
  ]
end
