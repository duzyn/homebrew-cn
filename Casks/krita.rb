cask "krita" do
  version "5.1.5"
  sha256 "0a4e742c91225b8563484cebc1a55b5356fd027d722a951f3df7847af10f72fd"

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
