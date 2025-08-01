cask "fontsmoothingadjuster" do
  version "2.0.0"
  sha256 "187401950b827c58262a9bb86878c5dd5820550c00ca414f971ce82837d7419f"

  url "https://mirror.ghproxy.com/https://github.com/bouncetechnologies/Font-Smoothing-Adjuster/releases/download/v#{version}/Font.Smoothing.Adjuster.#{version}.dmg",
      verified: "github.com/bouncetechnologies/Font-Smoothing-Adjuster/"
  name "Font Smoothing Adjuster"
  desc "Re-enable the font smoothing controls"
  homepage "https://www.fontsmoothingadjuster.com/"

  deprecate! date: "2025-07-14", because: :unmaintained

  depends_on macos: ">= :big_sur"

  app "Font Smoothing Adjuster.app"

  zap trash: [
    "~/Library/Application Support/com.bouncetechnologies.Font-Smoothing-Adjuster",
    "~/Library/Preferences/com.bouncetechnologies.Font-Smoothing-Adjuster.plist",
    "~/Library/Saved Application State/com.bouncetechnologies.Font-Smoothing-Adjuster.savedState",
  ]
end
