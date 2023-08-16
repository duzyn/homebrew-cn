cask "gplates" do
  version "2.2"
  sha256 "a4658d7dd7e123c53d847c7b98e91d3f9cf222beb0dadaea6a4868eddcf5d85a"

  url "https://downloads.sourceforge.net/gplates/#{version}/GPlates-#{version}.0-Darwin-x86_64.dmg?use_mirror=nchc",
      verified: "downloads.sourceforge.net/gplates/?use_mirror=nchc"
  name "GPlates"
  desc "Plate tectonics program"
  homepage "https://www.gplates.org/"

  app "GPlates-#{version}.0/GPlates.app"
end
