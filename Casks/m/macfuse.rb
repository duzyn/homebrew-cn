cask "macfuse" do
  version "4.8.3"
  sha256 "cf2951ce10d005711734196c43c55922d34ad45f6e0b27b15e345eeab1c92935"

  url "https://mirror.ghproxy.com/https://github.com/osxfuse/osxfuse/releases/download/macfuse-#{version}/macfuse-#{version}.dmg",
      verified: "github.com/osxfuse/osxfuse/"
  name "macFUSE"
  desc "File system integration"
  homepage "https://osxfuse.github.io/"

  livecheck do
    url "https://osxfuse.github.io/releases/CurrentRelease.plist"
    strategy :xml do |xml|
      xml.get_elements("//key[text()='Version']").map { |item| item.next_element&.text&.strip }
    end
  end

  auto_updates true
  conflicts_with cask: "macfuse@dev"
  depends_on macos: ">= :sierra"

  pkg "Extras/macFUSE #{version}.pkg"

  postflight do
    set_ownership ["/usr/local/include", "/usr/local/lib"]
  end

  uninstall pkgutil: [
    "io.macfuse.installer.components.core",
    "io.macfuse.installer.components.preferencepane",
  ]

  zap trash: "/Library/PreferencePanes/macFUSE.prefPane"

  caveats do
    kext
  end
end
