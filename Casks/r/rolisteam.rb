cask "rolisteam" do
  version "1.9.3"
  sha256 "473c2f26e6a7d3892088f0b9da1b563d86aba1eaa1dd223a79ef1d8c27f18160"

  url "https://downloads.sourceforge.net/rolisteam/rolisteam_v#{version}_MacOs.dmg?use_mirror=jaist",
      verified: "downloads.sourceforge.net/rolisteam/?use_mirror=jaist"
  name "Rolisteam"
  desc "Virtual tabletop software"
  homepage "https://rolisteam.org/"

  no_autobump! because: :requires_manual_review

  app "rolisteam.app"

  zap trash: [
    "~/Library/Preferences/com.rolisteam.rolisteam*",
    "~/Library/Saved Application State/com.yourcompany.rolisteam.savedState",
  ]

  caveats do
    requires_rosetta
  end
end
