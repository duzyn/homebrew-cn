cask "openaudible" do
  version "4.4.4"
  sha256 "c4e68a94424a98f1a79bd3f5301e336345680519297db2f8e69a20a5c65a3597"

  url "https://mirror.ghproxy.com/https://github.com/openaudible/openaudible/releases/download/v#{version}/OpenAudible_#{version}.dmg",
      verified: "github.com/openaudible/openaudible/"
  name "OpenAudible"
  desc "Audiobook manager for Audible users"
  homepage "https://openaudible.org/"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "OpenAudible.app"

  zap trash: "/Library/OpenAudible"
end
