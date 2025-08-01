cask "qlmobi" do
  version "0.6"
  sha256 "9a2400291248b3470edef5479fb8ccc11fdce02e50dc2d47f2a7bc81b614d15d"

  url "https://mirror.ghproxy.com/https://github.com/bfabiszewski/QLMobi/releases/download/v#{version}/QLMobi.qlgenerator.zip"
  name "QLMobi"
  desc "Quick Look plugin for Kindle ebook formats"
  homepage "https://github.com/bfabiszewski/QLMobi"

  no_autobump! because: :requires_manual_review

  qlplugin "QLMobi.qlgenerator"

  # No zap stanza required
end
