cask "nuage" do
  version "0.0.8"
  sha256 "6456f7969414e6dd1350d494e05ea92152ccc6d4c28faf5a2a6df6ba92ab6301"

  url "https://mirror.ghproxy.com/https://github.com/lbrndnr/nuage-macos/releases/download/v#{version}/Nuage.app.zip"
  name "Nuage"
  desc "Free and open-source SoundCloud client"
  homepage "https://github.com/lbrndnr/nuage-macos"

  depends_on macos: ">= :big_sur"

  app "Nuage.app"

  zap trash: [
    "~/Library/Application Support/CrashReporter/Nuage*.plist",
    "~/Library/Caches/ch.laurinbrandner.nuage",
    "~/Library/Containers/ch.laurinbrandner.nuage",
    "~/Library/Logs/DiagnosticReports/Nuage*.crash",
    "~/Library/Preferences/ch.laurinbrandner.nuage.plist",
  ]
end
