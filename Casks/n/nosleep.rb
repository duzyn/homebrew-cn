cask "nosleep" do
  version "1.5.1"
  sha256 "2dd5293c41a16a35deeaf903cc9f10092721b8869b69ef263231a73a4202cb5a"

  url "https://mirror.ghproxy.com/https://github.com/integralpro/nosleep/releases/download/#{version}/NoSleep-#{version}.dmg",
      verified: "github.com/integralpro/nosleep/"
  name "NoSleep"
  desc "Kernel extension that prevents sleep when the lid is closed"
  homepage "https://integralpro.github.io/nosleep/"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-06-27", because: :no_longer_available

  depends_on macos: ">= :high_sierra"

  app "NoSleep.app"

  # No zap stanza required
end
