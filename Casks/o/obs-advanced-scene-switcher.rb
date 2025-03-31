cask "obs-advanced-scene-switcher" do
  version "1.29.2"
  sha256 "c9440307f634c9fdab773013ddaff249f69098e56159998f6f94ea1832320e9f"

  url "https://mirror.ghproxy.com/https://github.com/WarmUpTill/SceneSwitcher/releases/download/#{version}/advanced-scene-switcher-#{version}-macos-universal.pkg",
      verified: "github.com/WarmUpTill/SceneSwitcher/"
  name "OBS Advanced Scene Switcher"
  desc "Automated scene switcher for OBS Studio"
  homepage "https://obsproject.com/forum/resources/advanced-scene-switcher.395"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on cask: "obs"

  pkg "advanced-scene-switcher-#{version}-macos-universal.pkg"

  uninstall pkgutil: [
              "'com.warmuptill.advanced-scene-switcher'",
              "com.warmuptill.advanced-scene-switcher",
            ],
            delete:  "/Library/Application Support/obs-studio/plugins/advanced-scene-switcher.plugin",
            rmdir:   "/Library/Application Support/obs-studio/plugins"

  # No zap stanza required
end
