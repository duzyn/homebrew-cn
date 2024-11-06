cask "nvidia-geforce-now" do
  version "2.0.68.145"
  sha256 :no_check

  url "https://download.nvidia.com/gfnpc/GeForceNOW-release.dmg"
  name "NVIDIA GeForce NOW"
  desc "Cloud gaming platform"
  homepage "https://www.nvidia.com/en-us/geforce-now/download/"

  livecheck do
    url "https://play.geforcenow.com/mall/shared/assets/config/config.json"
    strategy :json do |json|
      json.dig("build", "version")
    end
  end

  depends_on macos: ">= :el_capitan"

  # Renamed for consistency: app name is different in the Finder and in a shell.
  app "GeForceNOW.app", target: "NVIDIA GeForce NOW.app"

  zap trash: [
    "~/Library/Application Support/NVIDIA/GeForceNOW",
    "~/Library/Preferences/com.nvidia.gfnpc.mall.helper.plist",
  ]
end
