cask "insomnia@alpha" do
  version "11.0.0"
  sha256 "94f12179917d3fe059ff0afd5a04ff44fd7634afa403c37a61349c32b1eabb4b"

  url "https://mirror.ghproxy.com/https://github.com/Kong/insomnia/releases/download/core%40#{version}/Insomnia.Core-#{version}.dmg",
      verified: "github.com/Kong/insomnia/"
  name "Insomnia"
  desc "HTTP and GraphQL Client"
  homepage "https://insomnia.rest/"

  livecheck do
    url "https://updates.insomnia.rest/builds/check/mac?v=#{version.major}.0.0#{"-beta.0" if version.split("-")&.second}&app=com.insomnia.app&channel=beta"
    strategy :json do |json|
      json["name"]
    end
  end

  auto_updates true
  conflicts_with cask: "insomnia"
  depends_on macos: ">= :big_sur"

  app "Insomnia.app"

  zap trash: [
    "~/Library/Application Support/Insomnia",
    "~/Library/Caches/com.insomnia.app",
    "~/Library/Caches/com.insomnia.app.ShipIt",
    "~/Library/Cookies/com.insomnia.app.binarycookies",
    "~/Library/Preferences/ByHost/com.insomnia.app.ShipIt.*.plist",
    "~/Library/Preferences/com.insomnia.app.helper.plist",
    "~/Library/Preferences/com.insomnia.app.plist",
    "~/Library/Saved Application State/com.insomnia.app.savedState",
  ]
end
