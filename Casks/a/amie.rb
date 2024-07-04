cask "amie" do
  arch arm: "-arm64"

  version "240703.1.0"
  sha256 arm:   "fa6afab6133ebcefc3f91bf2802c84b293d28c0e51f59087fbd67ad43a98bb2c",
         intel: "ded617803633146284a10adef08b8793c6aa8244cc044686bb2808c76de46423"

  url "https://mirror.ghproxy.com/https://github.com/amieso/electron-releases/releases/download/v#{version}/Amie-#{version}#{arch}-mac.zip",
      verified: "github.com/amieso/electron-releases/"
  name "Amie"
  desc "Calendar and task manager"
  homepage "https://amie.so/"

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "Amie.app"

  zap trash: [
    "~/Library/Application Support/amie-desktop",
    "~/Library/Caches/amie-desktop",
    "~/Library/Logs/amie-desktop",
    "~/Library/Preferences/so.amie.electron-app.plist",
    "~/Library/Saved Application State/so.amie.electron-app.savedState",
  ]
end
