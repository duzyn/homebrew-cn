cask "seam-app" do
  version "1.1.6"
  sha256 "7f560776d2ef56699f7d334b49f0c0638a409c4d84721ef555fca11c9b16ff5d"

  url "https://releases.getseam.app/#{version}/Seam.dmg"
  name "Seam"
  desc "Productivity-first Dynamic Island for your Notch"
  homepage "https://getseam.app/"

  livecheck do
    url "https://releases.getseam.app/latest/release.json"
    strategy :json do |json|
      json["version"]
    end
  end

  auto_updates true
  depends_on macos: ">= :sonoma"

  app "Seam.app"

  zap trash: [
    "~/Library/Caches/app.seam",
    "~/Library/Logs/Seam",
    "~/Library/Preferences/seam.app.plist",
  ]
end
