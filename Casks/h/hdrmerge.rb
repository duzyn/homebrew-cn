cask "hdrmerge" do
  version "0.5.0"
  sha256 "7a87751b8f5aa005e7f41fcc009230f3db3f38cde66a3919184d66dd107518bf"

  url "https://mirror.ghproxy.com/https://github.com/jcelaya/hdrmerge/releases/download/v#{version}/HDRMerge.dmg",
      verified: "github.com/jcelaya/hdrmerge/"
  name "HDRMerge"
  desc "Creates raw images with extended dynamic range"
  homepage "https://jcelaya.github.io/hdrmerge/"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-07-12", because: :unmaintained
  disable! date: "2025-07-12", because: :unmaintained

  app "HDRMerge.app"
  binary "#{appdir}/HDRMerge.app/Contents/MacOS/hdrmerge"

  zap trash: "~/Library/Preferences/com.j-celaya.HdrMerge.plist"

  caveats do
    requires_rosetta
  end
end
