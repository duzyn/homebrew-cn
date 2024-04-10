cask "keka" do
  version "1.3.8"
  sha256 "8a8761bb1fb7d9de1f4538220359502fdb795521ed6c52e7e205ebf67c2fc904"

  url "https://mirror.ghproxy.com/https://github.com/aonez/Keka/releases/download/v#{version}/Keka-#{version}.dmg",
      verified: "github.com/aonez/Keka/"
  name "Keka"
  desc "File archiver"
  homepage "https://www.keka.io/"

  livecheck do
    url "https://u.keka.io/keka.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  conflicts_with cask: "keka-beta"

  app "Keka.app"
  # shim script (https://github.com/Homebrew/homebrew-cask/issues/18809)
  shimscript = "#{staged_path}/keka.wrapper.sh"
  binary shimscript, target: "keka"

  preflight do
    File.write shimscript, <<~EOS
      #!/bin/bash
      exec '#{appdir}/Keka.app/Contents/MacOS/Keka' '--cli' "$@"
    EOS
  end

  zap trash: [
    "~/Library/Application Scripts/com.aone.keka",
    "~/Library/Application Scripts/com.aone.keka.KekaFinderIntegration",
    "~/Library/Application Support/Keka",
    "~/Library/Caches/com.aone.keka",
    "~/Library/Containers/com.aone.keka",
    "~/Library/Containers/com.aone.keka.KekaFinderIntegration",
    "~/Library/Group Containers/*.group.com.aone.keka",
    "~/Library/Preferences/com.aone.keka.plist",
    "~/Library/Saved Application State/com.aone.keka.savedState",
  ]
end
