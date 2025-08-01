cask "obs-websocket" do
  version "5.0.1"
  sha256 "baf54b5dad9bc355c3af960ce94ddf8e88ed86c7d23d86e41baa8377cb1d4d06"

  url "https://mirror.ghproxy.com/https://github.com/obsproject/obs-websocket/releases/download/#{version}/obs-websocket-#{version}-macOS.pkg"
  name "obs-websocket"
  desc "Remote-control OBS Studio through WebSockets"
  homepage "https://github.com/obsproject/obs-websocket"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-10-27", because: :discontinued

  pkg "obs-websocket-#{version}-macOS.pkg"

  uninstall pkgutil: "com.obsproject.obs-websocket"
end
