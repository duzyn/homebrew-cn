cask "kid3" do
  # NOTE: "3" is not a version number, but an intrinsic part of the product name (ID3 tags)
  version "3.9.5"

  on_high_sierra :or_older do
    sha256 "1154c252cbc1b70dccebf6e1f48e00e16eb87e7cc8302d700db2236f1de5ed8e"

    url "https://downloads.sourceforge.net/kid3/kid3-#{version}-Darwin-Qt5.dmg?use_mirror=nchc",
        verified: "downloads.sourceforge.net/kid3/?use_mirror=nchc"

    depends_on macos: "<= :high_sierra"
  end
  on_mojave :or_newer do
    sha256 "1154c252cbc1b70dccebf6e1f48e00e16eb87e7cc8302d700db2236f1de5ed8e"

    url "https://downloads.sourceforge.net/kid3/kid3-#{version}-Darwin-amd64.dmg?use_mirror=nchc",
        verified: "downloads.sourceforge.net/kid3/?use_mirror=nchc"

    depends_on macos: ">= :mojave"
  end

  name "Kid3"
  desc "Audio tagger focusing on efficiency"
  homepage "https://kid3.sourceforge.io/"

  app "kid3.app"
  binary "#{appdir}/kid3.app/Contents/MacOS/kid3-cli"

  zap trash: "~/Library/Preferences/com.kid3.Kid3.plist"
end
