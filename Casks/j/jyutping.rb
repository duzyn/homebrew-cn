cask "jyutping" do
  version "0.56.0"
  sha256 "d8a2cf323cacb6366b2300baaa81af7e962069f0f7f85ba986f8233606c6efc8"

  url "https://mirror.ghproxy.com/https://github.com/yuetyam/jyutping/releases/download/#{version}/Jyutping-v#{version}-Mac-IME.pkg",
      verified: "github.com/yuetyam/jyutping/"
  name "Jyutping"
  desc "Cantonese Jyutping Input Method"
  homepage "https://jyutping.app/"

  livecheck do
    url "https://jyutping.app/appcast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on macos: ">= :monterey"

  pkg "Jyutping-v#{version}-Mac-IME.pkg"

  uninstall quit:    "org.jyutping.inputmethod.Jyutping",
            pkgutil: "org.jyutping.inputmethod.Jyutping",
            delete:  "/Library/Input Methods/Jyutping.app"

  zap trash: [
    "~/Library/Application Scripts/org.jyutping.inputmethod.Jyutping",
    "~/Library/Caches/org.jyutping.inputmethod.Jyutping",
    "~/Library/Containers/org.jyutping.inputmethod.Jyutping",
  ]
end
