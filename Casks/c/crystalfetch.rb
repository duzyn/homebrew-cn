cask "crystalfetch" do
  version "2.2.0"
  sha256 "6e428a419bc5deded21da0c9eafae4507fd5b2fb6e2c8cf8b59f97522f01deee"

  url "https://mirror.ghproxy.com/https://github.com/TuringSoftware/CrystalFetch/releases/download/v#{version}/CrystalFetch.dmg"
  name "Crystalfetch"
  desc "UI for creating Windows installer ISO from UUPDump"
  homepage "https://github.com/TuringSoftware/CrystalFetch"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :monterey"

  app "CrystalFetch.app"

  zap trash: [
    "~/Library/Application Scripts/llc.turing.CrystalFetch",
    "~/Library/Containers/llc.turing.CrystalFetch",
  ]
end
