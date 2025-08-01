cask "jpadilla-redis" do
  version "4.0.2-build.1"
  sha256 "1a4c0c82739a2bddbd5fa78f598cd28dd2c348467a12cb8de6687114f2bad4da"

  url "https://mirror.ghproxy.com/https://github.com/jpadilla/redisapp/releases/download/#{version}/Redis.zip",
      verified: "github.com/jpadilla/redisapp/"
  name "Redis"
  desc "App wrapper for Redis"
  homepage "https://jpadilla.github.io/redisapp/"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2025-04-15", because: :unmaintained

  app "Redis.app"

  zap trash: [
    "~/Library/Caches/io.blimp.Redis",
    "~/Library/Preferences/io.blimp.Redis.plist",
  ]

  caveats do
    requires_rosetta
  end
end
