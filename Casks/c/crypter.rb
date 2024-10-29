cask "crypter" do
  version "5.0.0"
  sha256 "ed136dbfacae87d52493e56e0e225d13203de997c54e7ac5f159feeadfcd4b7a"

  url "https://mirror.ghproxy.com/https://github.com/HR/Crypter/releases/download/v#{version}/Crypter-#{version}.dmg"
  name "Crypter"
  desc "Encryption software"
  homepage "https://github.com/HR/Crypter"

  deprecate! date: "2024-10-27", because: :unmaintained

  app "Crypter.app"

  zap trash: [
    "~/Library/Application Support/Crypter",
    "~/Library/Logs/Crypter",
    "~/Library/Preferences/com.github.hr.crypter.plist",
    "~/Library/Saved Application State/com.github.hr.crypter.savedState",
  ]

  caveats do
    requires_rosetta
  end
end
