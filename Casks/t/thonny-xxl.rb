cask "thonny-xxl" do
  version "3.3.13"
  sha256 "76acf2edb829c244256d2be773f061585fea79c47fb4e1994ddc546f5e71317c"

  url "https://mirror.ghproxy.com/https://github.com/thonny/thonny/releases/download/v#{version}/thonny-xxl-#{version}.pkg",
      verified: "github.com/thonny/thonny/"
  name "Thonny (XXL bundle)"
  desc "Python IDE for beginners"
  homepage "https://thonny.org/"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-07-04", because: :discontinued
  disable! date: "2025-07-04", because: :discontinued

  conflicts_with cask: "thonny"

  pkg "thonny-xxl-#{version}.pkg"

  uninstall quit:    "org.thonny.Thonny",
            pkgutil: "org.thonny.Thonny.component",
            delete:  "/Applications/Thonny.app"

  zap trash: [
    "~/Library/Saved Application State/org.thonny.Thonny.savedState",
    "~/Library/Thonny",
  ]
end
