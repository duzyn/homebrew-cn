cask "minecraft-education" do
  version "1.21.05.0"
  sha256 "16f26ab8ad0394816df028ee8f3d803b1c5c25482e7ad1db1773df7baf61f31b"

  url "https://downloads.minecrafteduservices.com/retailbuilds/MacOS/Minecraft_Education_#{version}.dmg",
      verified: "downloads.minecrafteduservices.com/"
  name "Minecraft Education Edition"
  desc "Educational version of Minecraft"
  homepage "https://education.minecraft.net/"

  livecheck do
    url "https://aka.ms/meeclientmacos"
    regex(/Minecraft[._-]Education[._-]?(\d+(?:[.-]\d+)+)\.dmg/i)
    strategy :header_match
  end

  depends_on macos: ">= :sierra"

  # Renamed for consistency: app name is different in the Finder and in a shell.
  app "minecraft-edu.app", target: "Minecraft Education.app"

  zap trash: [
    "~/Library/Application Support/com.microsoft.minecraftpe",
    "~/Library/Application Support/minecraftpe",
    "~/Library/Caches/com.microsoft.minecraftpe",
    "~/Library/HTTPStorages/com.microsoft.minecraftpe",
    "~/Library/HTTPStorages/com.microsoft.minecraftpe.binarycookies",
    "~/Library/Preferences/com.microsoft.minecraftpe.plist",
    "~/Library/Saved Application State/com.microsoft.minecraftpe.savedState",
    "~/Library/WebKit/com.microsoft.minecraftpe",
  ]

  caveats do
    requires_rosetta
  end
end
