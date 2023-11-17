cask "energybar" do
  version "1.7.19321"
  sha256 "96c06a93d5916001306af401046295926bf38996d767365c199131e068d85627"

  url "https://mirror.ghproxy.com/https://github.com/billziss-gh/EnergyBar/releases/download/v#{version.major_minor}/EnergyBar-#{version}.zip"
  name "EnergyBar"
  desc "Touch Bar widget application"
  homepage "https://github.com/billziss-gh/EnergyBar"

  depends_on macos: ">= :high_sierra"

  app "EnergyBar.app"

  caveats do
    discontinued
  end
end
