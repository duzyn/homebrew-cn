cask "streamlink-twitch-gui" do
  version "2.5.2"
  sha256 "bb653d1d358e462fb80f238fe031fa7842fd064d829a67a1fc8f184bb6933a1a"

  url "https://mirror.ghproxy.com/https://github.com/streamlink/streamlink-twitch-gui/releases/download/v#{version}/streamlink-twitch-gui-v#{version}-macOS.tar.gz"
  name "Streamlink Twitch GUI"
  desc "Multi platform Twitch.tv browser for Streamlink"
  homepage "https://github.com/streamlink/streamlink-twitch-gui/"

  depends_on formula: "streamlink"
  depends_on macos: ">= :high_sierra"

  app "Streamlink Twitch GUI.app"

  zap trash: [
    "~/Library/Application Support/streamlink-twitch-gui",
    "~/Library/Caches/streamlink-twitch-gui",
    "~/Library/Logs/streamlink-twitch-gui",
  ]
end
