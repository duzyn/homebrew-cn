cask "keka" do
  version "1.5.1"
  sha256 "2ee2648ab029b323298f841257c02dc5c4e19a1e081efcb4728f536f28263df3"

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
  conflicts_with cask: "keka@beta"

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
    "~/Library/Application Scripts/*.group.com.aone.keka",
    "~/Library/Application Scripts/com.aone.keka",
    "~/Library/Application Scripts/com.aone.keka.KekaFinderIntegration",
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.aone.keka.sfl*",
    "~/Library/Application Support/Keka",
    "~/Library/Caches/com.aone.keka",
    "~/Library/Containers/com.aone.keka",
    "~/Library/Containers/com.aone.keka.KekaFinderIntegration",
    "~/Library/Group Containers/*.group.com.aone.keka",
    "~/Library/Preferences/com.aone.keka.plist",
    "~/Library/Saved Application State/com.aone.keka.savedState",
  ]
end
