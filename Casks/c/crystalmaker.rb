cask "crystalmaker" do
  version "11.0.2"
  sha256 :no_check

  url "https://crystalmaker.com/downloads/crystalmaker#{version.major}_mac.zip"
  name "CrystalMaker"
  desc "Energy modelling for crystal & molecular structures"
  homepage "https://crystalmaker.com/crystalmaker/index.html"

  livecheck do
    url "https://crystalmaker.com/support/updates/VersionData-CMM.xml"
    regex(/<version[^>]+?number=["']?v?(\d+(?:\.\d+)+)["']?[^>]*?>/i)
  end

  depends_on macos: ">= :mojave"

  app "CrystalMaker.app"

  zap trash: [
    "~/Library/Application Scripts/com.crystalmaker.crystalmaker.v#{version.major}",
    "~/Library/Application Scripts/group.com.crystalmaker.bundle.v#{version.major}",
    "~/Library/Application Scripts/group.com.crystalmaker.crystalmaker.v#{version.major}",
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.crystalmaker.crystalmaker.v#{version.major}.sfl*",
    "~/Library/Containers/com.crystalmaker.crystalmaker.v#{version.major}",
    "~/Library/Group Containers/group.com.crystalmaker.bundle.v#{version.major}",
    "~/Library/Group Containers/group.com.crystalmaker.crystalmaker.v#{version.major}",
  ]
end
