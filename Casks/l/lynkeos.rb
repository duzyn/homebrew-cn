cask "lynkeos" do
  version "3.7"
  sha256 "e30ef976a84901fd1d55c0ea40c836b0735b2d02fbec684f54421f6f18149d6b"

  url "https://downloads.sourceforge.net/lynkeos/lynkeos/#{version}/Lynkeos-App-#{version.dots_to_hyphens}.zip?use_mirror=nchc",
      verified: "downloads.sourceforge.net/lynkeos/?use_mirror=nchc"
  name "Lynkeos"
  desc "Astronomical webcam image processing software"
  homepage "https://lynkeos.sourceforge.io/"

  livecheck do
    url "https://sourceforge.net/projects/lynkeos/rss?path=/lynkeos"
    regex(%r{url=.*?/v?(\d+(?:\.\d+)+)/Lynkeos[._-]App[\d._-]*\.zip}i)
  end

  app "Lynkeos-App-#{version.dots_to_hyphens}/Lynkeos.app"
end
