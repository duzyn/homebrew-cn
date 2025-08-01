cask "gdisk" do
  version "1.0.10"
  sha256 "38f0d2947803912cf0861f7a07ed2ae76979c88de5c20d6b10d6f9e7fe72b07d"

  url "https://downloads.sourceforge.net/gptfdisk/gdisk-#{version}.pkg?use_mirror=jaist"
  name "GPT fdisk"
  desc "Disk partitioning tool"
  homepage "https://sourceforge.net/projects/gptfdisk/"

  no_autobump! because: :requires_manual_review

  pkg "gdisk-#{version}.pkg"

  uninstall pkgutil: "com.rodsbooks.pkg.gdisk"

  # No zap stanza required
end
