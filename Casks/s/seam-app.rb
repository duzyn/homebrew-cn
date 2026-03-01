cask "seam-app" do
  version "1.1.8"
  sha256 "7a3a48e59cd78ff2870d8e741d5c53728b0c64015f9a940e88107d7876f1e5cb"

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
