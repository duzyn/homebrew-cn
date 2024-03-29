cask "ulbow" do
  version "1.10,2023.02"
  sha256 "3fdafc940c348f611b784229727bc576b889fcad9a3969ecac3a30f2c33c5c0b"

  url "https://eclecticlightdotcom.files.wordpress.com/#{version.csv.second.major}/#{version.csv.second.minor}/ulbow#{version.csv.first.no_dots}.zip",
      verified: "eclecticlightdotcom.files.wordpress.com/"
  name "Ulbow"
  desc "Log browser"
  homepage "https://eclecticlight.co/consolation-t2m2-and-log-utilities/"

  livecheck do
    url "https://mirror.ghproxy.com/https://raw.githubusercontent.com/hoakleyelc/updates/master/eclecticapps.plist"
    regex(%r{/(\d+)/(\d+)/ulbow(\d+)\.zip}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map do |match|
        "#{match[2].split("", 2).join(".")},#{match[0]}.#{match[1]}"
      end
    end
  end

  depends_on macos: ">= :sierra"

  app "ulbow#{version.csv.first.no_dots}/Ulbow.app"

  zap trash: [
    "~/Library/Caches/co.eclecticlight.Ulbow",
    "~/Library/HTTPStorages/co.eclecticlight.Ulbow",
    "~/Library/Preferences/co.eclecticlight.Ulbow.plist",
    "~/Library/Saved Application State/co.eclecticlight.Ulbow.savedState",
  ]
end
