cask "mixin" do
  version "1.9.0"
  sha256 "10ea24053db1e43d85502c3e230ba7a63b56edbe88480369ac9a98ae5f5d8fc3"

  url "https://mirror.ghproxy.com/https://github.com/MixinNetwork/flutter-app/releases/download/v#{version}/mixin-#{version}.dmg"
  name "Mixin Messenger Desktop"
  desc "Cryptocurrency wallet"
  homepage "https://github.com/MixinNetwork/flutter-app"

  # Not every GitHub release provides a file for macOS, so we check multiple
  # recent releases instead of only the "latest" release.
  livecheck do
    url :url
    regex(/^mixin[._-]v?(\d+(?:\.\d+)+)\.(?:dmg|pkg|zip)$/i)
    strategy :github_releases do |json, regex|
      json.map do |release|
        next if release["draft"] || release["prerelease"]

        release["assets"]&.map do |asset|
          match = asset["name"]&.match(regex)
          next if match.blank?

          match[1]
        end
      end.flatten
    end
  end

  auto_updates true

  app "Mixin.app"

  zap trash: [
    "~/Library/Application Scripts/one.mixin.messenger.desktop",
    "~/Library/Application Support/one.mixin.messenger.desktop",
    "~/Library/Containers/one.mixin.messenger.desktop",
    "~/Library/Saved Application State/one.mixin.messenger.desktop.savedState",
  ]
end
