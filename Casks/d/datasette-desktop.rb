cask "datasette-desktop" do
  version "0.2.3"
  sha256 "a708f435afebf5c95d7ea4026699b6b64db6b7e08f9581dd5a143109a5cb986d"

  url "https://mirror.ghproxy.com/https://github.com/simonw/datasette-app/releases/download/#{version}/Datasette.app.zip",
      verified: "github.com/simonw/datasette-app/"
  name "Datasette"
  desc "Desktop application that wraps Datasette"
  homepage "https://datasette.io/desktop"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :high_sierra"

  app "Datasette.app"

  zap trash: [
    "~/Library/Application Support/Datasette",
    "~/Library/Caches/io.datasette.app.ShipIt",
    "~/Library/Preferences/io.datasette.app.plist",
    "~/Library/Saved Application State/io.datasette.app.savedState",
  ]

  caveats do
    requires_rosetta
  end
end
