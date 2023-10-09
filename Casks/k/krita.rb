cask "krita" do
  version "5.2.0"
  sha256 "78fbd311f1d5732f3ae215cf622189de0ace1a75512b9f8789d5e2b649ed386e"

  url "https://mirrors.ustc.edu.cn/kde/stable/krita/#{version}/krita-#{version}.dmg",
      verified: "mirrors.ustc.edu.cn/kde/stable/krita/"
  name "Krita"
  desc "Free and open-source painting and sketching program"
  homepage "https://krita.org/"

  livecheck do
    url "https://mirrors.ustc.edu.cn/kde/stable/krita/"
    regex(%r{href="(\d+(?:\.\d+)+)/"}i)
  end

  depends_on macos: ">= :sierra"

  app "krita.app"

  zap trash: [
    "~/Library/Application Support/krita",
    "~/Library/Preferences/kritadisplayrc",
    "~/Library/Preferences/kritarc",
    "~/Library/Saved Application State/org.krita.savedState",
  ]
end
