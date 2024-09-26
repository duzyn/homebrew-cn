cask "heptabase" do
  arch arm: "-arm64"

  version "1.40.0"
  sha256 arm:   "a638991f44aa7099def5add23ed3c6da621ebabe1234241d6a93b61ce5992b45",
         intel: "6ac50a38e98a103d0d3706451b8aa4e4e684e614bde08388d050b81c081b6d3c"

  url "https://mirror.ghproxy.com/https://github.com/heptameta/project-meta/releases/download/v#{version}/Heptabase-#{version}#{arch}-mac.zip",
      verified: "github.com/heptameta/project-meta/"
  name "Hepta"
  desc "Note-taking tool for visual learning"
  homepage "https://heptabase.com/"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true

  app "Heptabase.app"

  zap trash: [
    "~/Library/Preferences/app.projectmeta.projectmeta.plist",
    "~/Library/Saved Application State/app.projectmeta.projectmeta.savedState",
  ]
end
