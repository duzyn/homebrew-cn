cask "launchrocket" do
  version "0.7"
  sha256 "51dc78902fecfb7ec26ab5c6516b84d1c62692349864ef48aca2fde81bd2ef4a"

  url "https://mirror.ghproxy.com/https://github.com/jimbojsb/launchrocket/releases/download/v#{version}/LaunchRocket.prefPane.zip"
  name "LaunchRocket"
  desc "Preference pane to manage Homebrew-installed services"
  homepage "https://github.com/jimbojsb/launchrocket"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  prefpane "LaunchRocket.prefPane"

  zap trash: "~/Library/Preferences/com.joshbutts.launchrocket.plist"

  caveats do
    requires_rosetta
  end
end
