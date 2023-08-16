cask "rolisteam" do
  version "1.9.3"
  sha256 "473c2f26e6a7d3892088f0b9da1b563d86aba1eaa1dd223a79ef1d8c27f18160"

  url "https://downloads.sourceforge.net/rolisteam/rolisteam_v#{version}_MacOs.dmg?use_mirror=nchc",
      verified: "downloads.sourceforge.net/rolisteam/?use_mirror=nchc"
  name "Rolisteam"
  desc "Virtual tabletop software"
  homepage "https://rolisteam.org/"

  app "rolisteam.app"
end
