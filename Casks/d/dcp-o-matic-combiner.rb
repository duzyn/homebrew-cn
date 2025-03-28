cask "dcp-o-matic-combiner" do
  version "2.18.15"
  sha256 "43c45be8135e50b6acc61d0210feddee6d9bf28c1f4bdaec2234b0b9ca898d2d"

  url "https://dcpomatic.com/dl.php?id=osx-10.10-combiner&version=#{version}"
  name "DCP-o-matic-combiner"
  desc "Convert video, audio and subtitles into DCP (Digital Cinema Package)"
  homepage "https://dcpomatic.com/"

  livecheck do
    cask "dcp-o-matic"
  end

  app "DCP-o-matic #{version.major} Combiner.app"

  # No zap stanza required
end
