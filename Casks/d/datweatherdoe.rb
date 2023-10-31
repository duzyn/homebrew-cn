cask "datweatherdoe" do
  on_catalina :or_older do
    version "2.2.0"
    sha256 "0e7c7a9a770f3f7e10a17610e4e8670f3c7050a872b1cb2947bfbbbfda94174f"

    livecheck do
      skip "Legacy version for Catalina and earlier"
    end
  end
  on_big_sur :or_newer do
    version "4.0.0"
    sha256 "41c1e72855448ba61649be130af2ff9f77b35588eba0f50ce96080939f8d0b3d"

    livecheck do
      url :url
      strategy :github_latest
    end
  end

  url "https://ghproxy.com/https://github.com/inderdhir/DatWeatherDoe/releases/download/#{version}/DatWeatherDoe-#{version}.dmg"
  name "DatWeatherDoe"
  desc "Menu bar weather app"
  homepage "https://github.com/inderdhir/DatWeatherDoe"

  depends_on macos: ">= :big_sur"

  app "DatWeatherDoe.app"

  zap trash: "~/Library/Preferences/com.inderdhir.DatWeatherDoe.plist"
end
