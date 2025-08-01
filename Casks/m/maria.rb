cask "maria" do
  version "1.2.6,1701213"
  sha256 "49fdca9fb362b96d9e51a5663edc4a7f2d2e27e3f9d14ffcaea60fdb2a155e06"

  url "https://mirror.ghproxy.com/https://github.com/shincurry/Maria/releases/download/v#{version.csv.first}/Maria_v#{version.csv.first}_build#{version.csv.second}.dmg"
  name "Maria"
  desc "App/widget for aria2 download tool"
  homepage "https://github.com/shincurry/Maria"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  app "Maria.app"
end
