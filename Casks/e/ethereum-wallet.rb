cask "ethereum-wallet" do
  version "0.11.1"
  sha256 "df52a7ad6519aa92d17a743d0cb3bcf3080c2c72e31b1a58fbfa4581069dc4c8"

  url "https://mirror.ghproxy.com/https://github.com/ethereum/mist/releases/download/v#{version}/Ethereum-Wallet-macosx-#{version.dots_to_hyphens}.dmg"
  name "Ethereum Wallet"
  name "Mist"
  desc "Browser for Ðapps on the Ethereum network"
  homepage "https://github.com/ethereum/mist"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  app "Ethereum Wallet.app"

  zap trash: [
    "~/Library/Application Support/Ethereum Wallet",
    "~/Library/Preferences/com.ethereum.wallet.helper.plist",
    "~/Library/Preferences/com.ethereum.wallet.plist",
  ]

  caveats do
    requires_rosetta
  end
end
