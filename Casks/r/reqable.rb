cask "reqable" do
  arch arm: "arm64", intel: "x86_64"

  version "2.21.4"
  sha256 arm:   "c9a0c2302e062dcb9d971b058641eefaf8c471aebc48f997cfdb1df52e954c9a",
         intel: "c106d43154070f0cd955076d193f3cc78e5285418ec027df37c0769dfe7704bc"

  url "https://mirror.ghproxy.com/https://github.com/reqable/reqable-app/releases/download/#{version}/reqable-app-macos-#{arch}.dmg",
      verified: "github.com/reqable/reqable-app/"
  name "Reqable"
  desc "Advanced API Debugging Proxy"
  homepage "https://reqable.com/"

  auto_updates true

  app "Reqable.app"

  uninstall_postflight do
    stdout, * = system_command "/usr/bin/security",
                               args: ["find-certificate", "-a", "-c", "Reqable Proxy", "-Z"],
                               sudo: true
    hashes = stdout.lines.grep(/^SHA-256 hash:/) { |l| l.split(":").second.strip }
    hashes.each do |h|
      system_command "/usr/bin/security",
                     args: ["delete-certificate", "-Z", h],
                     sudo: true
    end
  end

  zap trash: [
    "~/Library/Caches/Reqable",
    "~/Library/Preferences/com.reqable.macosx.plist",
  ]
end
