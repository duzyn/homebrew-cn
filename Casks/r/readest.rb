cask "readest" do
  version "0.9.33"
  sha256 "fe052f9c06eb479fd4a7ddc7b1d7b7ee1de21dc483c286cedb504456373b342d"

  url "https://mirror.ghproxy.com/https://github.com/readest/readest/releases/download/v#{version}/Readest_#{version}_universal.dmg",
      verified: "github.com/readest/readest/"
  name "Readest"
  desc "Ebook reader"
  homepage "https://readest.com/"

  depends_on macos: ">= :monterey"

  app "Readest.app"

  zap trash: [
    "~/Library/Application Support/com.bilingify.readest",
    "~/Library/Caches/com.bilingify.readest",
    "~/Library/Caches/readest",
    "~/Library/Preferences/com.bilingify.readest.plist",
    "~/Library/WebKit/com.bilingify.readest",
    "~/Library/WebKit/readest",
  ]
end
