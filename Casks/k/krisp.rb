cask "krisp" do
  arch arm: "arm64", intel: "x64"
  livecheck_arch = on_arch_conditional arm: "arm", intel: "64"

  version "3.3.5"
  sha256 arm:   "839d6b0e444c17fe7c9ba8efad714b0c9a7b49ac8f71fc52f7beb74a600cc91d",
         intel: "d545c14725d74e6c5d8e8703b1bbcf55c774e6f08b2c3cc948bb27eba81d08c8"

  url "https://cdn.krisp.ai/mp/mn/#{version.major_minor}/mac/Krisp_#{version}_#{arch}.pkg"
  name "Krisp"
  desc "Noise cancelling application"
  homepage "https://krisp.ai/"

  livecheck do
    url "https://api.krisp.ai/v2/download/mac?package=package_#{livecheck_arch}"
    regex(%r{/Krisp[._-]v?(\d+(?:\.\d+)+)[._-]#{arch}\.pkg}i)
    strategy :header_match
  end

  auto_updates true
  depends_on macos: ">= :mojave"

  pkg "krisp_#{version}_#{arch}.pkg"

  uninstall launchctl: [
              "ai.krisp.krispMac*",
              "krisp",
            ],
            quit:      "ai.krisp.krispMac",
            pkgutil:   "ai.krisp.krispMac*",
            delete:    "/Applications/krisp.app"

  zap trash: [
    "~/Library/Application Scripts/ai.krisp.krispMac.LaunchHelper",
    "~/Library/Application Support/ai.krisp.krispMac",
    "~/Library/Caches/ai.krisp.krispMac",
    "~/Library/Containers/ai.krisp.krispMac.LaunchHelper",
    "~/Library/HTTPStorages/ai.krisp.krispMac.*",
    "~/Library/LaunchAgents/ai.krisp.krispMac.cameraAssistant.plist",
    "~/Library/Preferences/ai.krisp.krispMac.plist",
  ]
end
