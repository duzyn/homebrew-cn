cask "sitesucker-pro" do
  on_catalina :or_older do
    version "3.2.7"
    sha256 "dd61a113ad86b580e0faf97b4aa86290e038bb3e098f2d19e67fc9e194ce1a3e"

    livecheck do
      skip "Legacy version"
    end
  end
  on_big_sur do
    version "5.2"
    sha256 "244fa73a0aa73b3786ee6eb4e5d6f6438942853d6d58c5de38b92f11e8d44428"

    livecheck do
      skip "Legacy version"
    end
  end
  on_monterey :or_newer do
    version "5.7"
    sha256 "e3a38ef0fa59d0a96ccd9ee3327f0f6f6e2221e2af3837af7f3947fb045797d1"

    livecheck do
      url "https://ricks-apps.com/osx/sitesucker/pro-versions.plist"
      strategy :xml do |xml|
        version = xml.elements["//dict/key[text()='App Version']"]&.next_element&.text
        next if version.blank?

        version.strip
      end
    end
  end

  url "https://ricks-apps.com/osx/sitesucker/archive/#{version.major}.x/#{version.major_minor}.x/#{version}/SiteSucker_Pro_#{version}.dmg"
  name "SiteSucker Pro"
  desc "Website downloader tool"
  homepage "https://ricks-apps.com/osx/sitesucker/index.html"

  auto_updates true
  depends_on macos: ">= :mojave"

  app "SiteSucker Pro.app"

  zap trash: [
    "~/Library/Application Scripts/us.sitesucker.mac.sitesucker-pro",
    "~/Library/Containers/us.sitesucker.mac.sitesucker-pro",
  ]
end
