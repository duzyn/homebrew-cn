cask "nsregextester" do
  version "1.0"
  sha256 :no_check

  url "https://mirror.ghproxy.com/https://raw.githubusercontent.com/aaronvegh/nsregextester/master/NSRegexTester.zip",
      verified: "mirror.ghproxy.com/https://raw.githubusercontent.com/aaronvegh/nsregextester/master/"
  name "NSRegexTester"
  homepage "https://github.com/aaronvegh/nsregextester"

  livecheck do
    url :url
    strategy :extract_plist
  end

  app "NSRegexTester.app"
end
