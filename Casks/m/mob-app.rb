cask "mob-app" do
  version "0.2.2"
  sha256 "a70d66d92310737d9599215d558670a45265795be0be980934a91e9880eb4a73"

  url "https://mirror.ghproxy.com/https://github.com/zenghongtu/Mob/releases/download/v#{version}/Mob-#{version}-mac.dmg"
  name "Mob"
  homepage "https://github.com/zenghongtu/Mob"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  app "Mob.app"

  zap trash: "~/Library/Application Support/mob"
end
