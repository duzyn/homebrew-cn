cask "auryo" do
  version "2.5.4"
  sha256 "481884ddfad1c617e7cbe148d6d0cb9bcd0570d5f78bde8b1aeba36a2921057c"

  url "https://mirror.ghproxy.com/https://github.com/Superjo149/auryo/releases/download/v#{version}/Auryo-#{version}.dmg",
      verified: "github.com/Superjo149/auryo/"
  name "Auryo"
  desc "Unofficial desktop app for Soundcloud"
  homepage "https://auryo.com/"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-09-30", because: :discontinued

  app "Auryo.app"
end
