cask "nzbget-app" do
  version "21.1"
  sha256 "f8d7fe6e0b8e540a5adc02eda20314f10093f58ca4a85925f607e45e9f02c5ec"

  url "https://mirror.ghproxy.com/https://github.com/nzbget/nzbget/releases/download/v#{version}/nzbget-#{version}-bin-macos.zip",
      verified: "github.com/nzbget/nzbget/"
  name "NZBGet"
  desc "Usenet downloader focusing on efficiency"
  homepage "https://nzbget.net/"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-02-19", because: :discontinued
  disable! date: "2025-02-19", because: :discontinued

  app "NZBGet.app"

  zap trash: [
    "~/Library/Application Support/NZBGet",
    "~/Library/Preferences/net.sourceforge.nzbget.plist",
  ]

  caveats do
    requires_rosetta
  end
end
