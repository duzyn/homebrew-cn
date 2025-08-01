cask "thonny" do
  version "4.1.7"
  sha256 "32c7540498b9df038abb286363f2eab13b5ba6a731c3cb3d9e348226762225d9"

  url "https://mirror.ghproxy.com/https://github.com/thonny/thonny/releases/download/v#{version}/thonny-#{version}.pkg",
      verified: "github.com/thonny/thonny/"
  name "Thonny"
  desc "Python IDE for beginners"
  homepage "https://thonny.org/"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  conflicts_with cask: "thonny-xxl"

  pkg "thonny-#{version}.pkg"

  uninstall quit:    "org.thonny.Thonny",
            pkgutil: "org.thonny.Thonny.component",
            delete:  "/Applications/Thonny.app"

  zap trash: [
    "~/Library/Saved Application State/org.thonny.Thonny.savedState",
    "~/Library/Thonny",
  ]
end
