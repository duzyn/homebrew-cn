cask "ente-auth" do
  version "4.2.7"
  sha256 "32392666334e05df98b32164029d35b2ed7169f2caaaa07bc2e56c7a9952091b"

  url "https://mirror.ghproxy.com/https://github.com/ente-io/ente/releases/download/auth-v#{version}/ente-auth-v#{version}.dmg",
      verified: "github.com/ente-io/ente/"
  name "Ente Auth"
  desc "Desktop client for Ente Auth"
  homepage "https://ente.io/auth/"

  livecheck do
    url :url
    regex(/^auth[._-]v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  depends_on macos: ">= :mojave"

  app "Ente Auth.app"

  zap trash: [
    "~/Library/Application Scripts/io.ente.auth.mac",
    "~/Library/Containers/io.ente.auth.mac",
  ]
end
