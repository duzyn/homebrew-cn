cask "opencloud" do
  arch arm: "arm64", intel: "x86_64"

  version "1.0.0"
  sha256 arm:   "9f98e18b6dfa4164198d8b3abae2855d11e5da89dd75e99cd50f2ca8b15cf625",
         intel: "a9b44fea546040377f9c2bcce6da616cc0618603480e5df59f7ed20b7a427edf"

  url "https://mirror.ghproxy.com/https://github.com/opencloud-eu/desktop/releases/download/v#{version}/OpenCloud_Desktop-v#{version}-macos-clang-#{arch}.pkg"
  name "OpenCloud Desktop"
  desc "Desktop syncing client for OpenCloud"
  homepage "https://github.com/opencloud-eu/desktop"

  # TODO: Update this to use the `GithubLatest` strategy (without a regex or
  # `strategy` block) when a stable version becomes available.
  livecheck do
    url :url
    regex(/^v?(\d+(?:\.\d+)+.+)$/i)
    strategy :github_releases do |json, regex|
      json.filter_map do |release|
        next if release["draft"]

        match = release["tag_name"]&.match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  auto_updates true
  depends_on macos: ">= :monterey"

  pkg "OpenCloud_Desktop-v#{version}-macos-clang-#{arch}.pkg"

  uninstall pkgutil: [
    "eu.opencloud.client",
    "eu.opencloud.desktop",
    "eu.opencloud.finderPlugin",
  ]

  zap trash: [
    "~/Library/Application Scripts/eu.opencloud.desktopclient.FinderSyncExt",
    "~/Library/Application Support/OpenCloud",
    "~/Library/Caches/eu.opencloud.desktopclient",
    "~/Library/Containers/eu.opencloud.desktopclient.FinderSyncExt",
    "~/Library/Group Containers/9B5WD74GWJ.eu.opencloud.desktopclient",
    "~/Library/Preferences/eu.opencloud.desktopclient.plist",
    "~/Library/Preferences/OpenCloud",
  ]
end
