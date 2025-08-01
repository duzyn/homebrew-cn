cask "eiskaltdcpp" do
  version "2.4.2"
  sha256 "85b77157892985c0cc0e4c2b9244b4095bf5738f5e94e7a0941551e0c9a7a009"

  url "https://downloads.sourceforge.net/eiskaltdcpp/EiskaltDC++-#{version}-x86_64.dmg?use_mirror=jaist"
  name "EiskaltDC++"
  desc "Filesharing using Direct Connect and ADC protocols"
  homepage "https://sourceforge.net/projects/eiskaltdcpp/"

  livecheck do
    url "https://sourceforge.net/projects/eiskaltdcpp/rss?path=/macOS"
    regex(%r{url=.*?/EiskaltDC%2B%2B[._-]v?(\d+(?:\.\d+)+)(?:-[^"']+?)?\.dmg}i)
  end

  no_autobump! because: :requires_manual_review

  app "EiskaltDC++.app"

  zap trash: [
    "~/.config/eiskaltdc++",
    "~/.local/share/eiskaltdc++",
  ]

  caveats do
    requires_rosetta
  end
end
