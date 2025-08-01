cask "seaglass" do
  version "0.0.525-f5a1376"
  sha256 "ff96050e21abef5e11bba60a3c6e6a98a303239a0c36637c8ceb8fa539c7f93a"

  url "https://mirror.ghproxy.com/https://github.com/neilalexander/seaglass/releases/download/#{version}/Seaglass-#{version}.zip"
  name "Seaglass"
  desc "Matrix client"
  homepage "https://github.com/neilalexander/seaglass/"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "Seaglass.app"
end
