cask "exifcleaner" do
  version "3.6.0"
  sha256 "459b296b000a7cd614713772e9b4ecf1604d3bb10926ab2346e8ea88e44df323"

  url "https://mirror.ghproxy.com/https://github.com/szTheory/exifcleaner/releases/download/v#{version}/ExifCleaner-#{version}.dmg",
      verified: "github.com/szTheory/exifcleaner/"
  name "ExifCleaner"
  desc "Metadata cleaner"
  homepage "https://exifcleaner.com/"

  no_autobump! because: :requires_manual_review

  app "ExifCleaner.app"

  zap trash: [
    "~/Library/Application Support/ExifCleaner",
    "~/Library/Saved Application State/com.exifcleaner.savedState",
  ]

  caveats do
    requires_rosetta
  end
end
