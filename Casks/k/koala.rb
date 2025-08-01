cask "koala" do
  version "2.3.0"
  sha256 "6494408132c8818956a0a0423ed284120506bad0d5dc2349e8ffa7e16c9696bc"

  url "https://mirror.ghproxy.com/https://github.com/oklai/koala/releases/download/v#{version}/Koala.dmg",
      verified: "github.com/oklai/koala/"
  name "Koala"
  homepage "http://koala-app.com/"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-07-17", because: :unmaintained
  disable! date: "2025-07-17", because: :unmaintained

  app "Koala.app"

  caveats do
    requires_rosetta
  end
end
