cask "ganache" do
  version "2.5.4"
  sha256 "1053a5405b8448ebbe7d2e34423e3393fbe9e3e5df7e96305eb34c41495f8ce1"

  url "https://ghproxy.com/github.com/trufflesuite/ganache-ui/releases/download/v#{version}/Ganache-#{version}-mac.dmg",
      verified: "github.com/trufflesuite/ganache-ui/"
  name "Ganache"
  desc "Personal blockchain for Ethereum development"
  homepage "https://truffleframework.com/ganache/"

  app "Ganache.app"
end
