cask "pycharm-ce" do
  arch arm: "-aarch64"

  version "2023.2.2,232.9921.89"
  sha256 arm:   "2bcddf3e58902578745dd1803f17ebd18f4c98dc76bf48b0945afbc7bae45832",
         intel: "f482b6d451efec897764487b116f7bf09d507a5ebfb841c33e2abd2441c3b3a7"

  url "https://download.jetbrains.com/python/pycharm-community-#{version.csv.first}#{arch}.dmg"
  name "Jetbrains PyCharm Community Edition"
  name "PyCharm CE"
  desc "IDE for Python programming - Community Edition"
  homepage "https://www.jetbrains.com/pycharm/"

  livecheck do
    url "https://data.services.jetbrains.com/products/releases?code=PCC&latest=true&type=release"
    strategy :json do |json|
      json["PCC"].map do |release|
        "#{release["version"]},#{release["build"]}"
      end
    end
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "PyCharm CE.app"

  uninstall_postflight do
    ENV["PATH"].split(File::PATH_SEPARATOR).map { |path| File.join(path, "charm") }.each do |path|
      if File.readable?(path) &&
         File.readlines(path).grep(/# see com.intellij.idea.SocketLock for the server side of this interface/).any?
        File.delete(path)
      end
    end
  end

  zap trash: [
    "~/Library/Application Support/JetBrains/PyCharmCE#{version.major_minor}",
    "~/Library/Application Support/PyCharm#{version.major_minor}",
    "~/Library/Caches/com.apple.python/Applications/PyCharm CE.app",
    "~/Library/Caches/JetBrains/PyCharmCE#{version.major_minor}",
    "~/Library/Caches/PyCharm#{version.major_minor}",
    "~/Library/Caches/PyCharmCE#{version.major_minor}",
    "~/Library/Logs/JetBrains/PyCharmCE#{version.major_minor}",
    "~/Library/Logs/PyCharm#{version.major_minor}",
    "~/Library/Logs/PyCharmCE#{version.major_minor}",
    "~/Library/Preferences/com.jetbrains.pycharm.ce.plist",
    "~/Library/Preferences/jetbrains.jetprofile.asset.plist",
    "~/Library/Preferences/PyCharm#{version.major_minor}",
    "~/Library/Preferences/PyCharmCE#{version.major_minor}",
    "~/Library/Saved Application State/com.jetbrains.pycharm.ce.savedState",
    "~/Library/Saved Application State/com.jetbrains.pycharm.savedState",
  ]
end