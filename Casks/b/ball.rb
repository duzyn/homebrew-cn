cask "ball" do
  version "1"
  sha256 "f3b1794971cc34fadcd817c8c4ed1ad9e791143254696fb6e78fea1294bccbd1"

  url "https://mirror.ghproxy.com/https://github.com/nate-parrott/ball/releases/download/v#{version}/Ball.dmg"
  name "Ball"
  desc "Utility that adds a ball to your dock"
  homepage "https://github.com/nate-parrott/ball"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :ventura"

  app "Ball.app"

  # No zap stanza required
end
