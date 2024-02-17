cask "dcp-o-matic-disk-writer" do
  version "2.16.76"
  sha256 "c09eb15cd06359d31abd7f8622dc3be4928c7c418e9b72f3c5b2b14898a578a9"

  url "https://dcpomatic.com/dl.php?id=osx-10.10-disk&version=#{version}"
  name "DCP-o-matic Disk Writer"
  desc "Convert video, audio and subtitles into DCP (Digital Cinema Package)"
  homepage "https://dcpomatic.com/"

  livecheck do
    cask "dcp-o-matic"
  end

  app "DCP-o-matic #{version.major} Disk Writer.app"

  # No zap stanza required
end
