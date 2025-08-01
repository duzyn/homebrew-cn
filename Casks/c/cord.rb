cask "cord" do
  version "0.5.7"
  sha256 "8f505b12b94167100b3b8b44ed3cee32ffcc94b73dc44fe0ecc896151f114100"

  url "https://downloads.sourceforge.net/cord/cord/#{version.csv.first}/CoRD_#{version}.zip?use_mirror=jaist"
  name "CoRD"
  desc "Remote desktop client"
  homepage "https://cord.sourceforge.net/"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-07-17", because: :discontinued
  disable! date: "2025-07-17", because: :discontinued

  app "CoRD.app"

  zap trash: [
    "~/Library/Application Support/CoRD",
    "~/Library/Preferences/net.sf.cord.plist",
    "~/Library/Saved Application State/net.sf.cord.savedState",
  ]

  caveats do
    requires_rosetta
  end
end
