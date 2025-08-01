cask "servpane" do
  version "0.1.1"
  sha256 "07f37334bc723d4aefa81411e604d4a20306d89b1553500b8acc715ee503f314"

  url "https://mirror.ghproxy.com/https://github.com/aderyabin/ServPane/releases/download/v#{version}/ServPane-#{version}.dmg"
  name "ServPane"
  desc "Launchd menu bar app"
  homepage "https://github.com/aderyabin/ServPane"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-12-30", because: :unmaintained

  app "ServPane.app"

  caveats do
    requires_rosetta
  end
end
