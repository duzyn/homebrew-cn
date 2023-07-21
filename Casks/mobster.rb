cask "mobster" do
  version "0.0.48"
  sha256 "47ab506e59d9a3491f06943baecd1b225277e472ce71bc5052efc9d152712233"

  url "https://ghproxy.com/https://github.com/dillonkearns/mobster/releases/download/v#{version}/Mobster-#{version}.dmg"
  name "Mobster"
  desc "Pair and mob programming timer"
  homepage "https://github.com/dillonkearns/mobster/"

  app "Mobster.app"

  zap trash: [
    "~/Library/Application Support/Mobster",
    "~/Library/Preferences/com.dillonkearns.mobster.helper.plist",
    "~/Library/Preferences/com.dillonkearns.mobster.plist",
    "~/Library/Saved Application State/com.dillonkearns.mobster.savedState",
  ]
end
