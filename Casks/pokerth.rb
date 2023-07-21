cask "pokerth" do
  version "1.1.2"
  sha256 "bce46072dd13ebfa6253a49aca92d9ca28c28f77cb63831d5ed67b7b167ef7a3"

  url "https://downloads.sourceforge.net/pokerth/PokerTH_#{version}.dmg?use_mirror=nchc",
      verified: "downloads.sourceforge.net/pokerth/?use_mirror=nchc"
  name "PokerTH"
  desc "Free Texas hold'em poker"
  homepage "https://www.pokerth.net/"

  app "pokerth.app"
end
