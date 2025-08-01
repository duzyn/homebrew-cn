cask "bitbar" do
  version "1.10.1"
  sha256 "8a7013dca92715ba80cccef98b84dd1bc8d0b4c4b603f732e006eb204bab43fa"

  url "https://mirror.ghproxy.com/https://github.com/matryer/bitbar/releases/download/v#{version}/BitBar.app.zip"
  name "BitBar"
  desc "Utility to display the output from any script or program in the menu bar"
  homepage "https://github.com/matryer/bitbar/"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-12-30", because: :unmaintained

  app "BitBar.app"

  zap trash: [
    "~/Library/BitBar Plugins",
    "~/Library/Caches/com.matryer.BitBar",
    "~/Library/Preferences/com.matryer.BitBar.plist",
  ]
end
