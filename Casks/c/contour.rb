cask "contour" do
  version "0.4.1.6292"
  sha256 "c168263e9e50ece9b9f4e4168143f66bbc7c6b0a8b7392020a192c54dcf24a8d"

  url "https://mirror.ghproxy.com/https://github.com/contour-terminal/contour/releases/download/v#{version}/contour-#{version}-osx.dmg"
  name "contour"
  desc "Terminal emulator"
  homepage "https://github.com/contour-terminal/contour/"

  app "contour.app"
  binary "contour.app/Contents/MacOS/contour"
  binary "contour.app/Contents/Resources/shell-integration/shell-integration.zsh",
         target: "#{HOMEBREW_PREFIX}/share/zsh/site-functions/_contour"
  binary "contour.app/Contents/Resources/terminfo/63/contour",
         target: "#{ENV.fetch("TERMINFO", "~/.terminfo")}/63/contour"

  zap trash: "~/.config/contour"
end
