cask "charles@4" do
  version "4.6.7"
  sha256 "ba16148c7a6b3723488cc95968d96fba1de0807ad8e47467a2b5ac3ad13ff22b"

  url "https://www.charlesproxy.com/assets/release/#{version}/charles-proxy-#{version}.dmg"
  name "Charles"
  desc "Web debugging Proxy application"
  homepage "https://www.charlesproxy.com/"

  livecheck do
    url "https://www.charlesproxy.com/documentation/version-history/"
    regex(/Version (4(?:\.\d+)+)/i)
  end

  app "Charles.app"

  uninstall_postflight do
    stdout, * = system_command "/usr/bin/security",
                               args: ["find-certificate", "-a", "-c", "Charles", "-Z"],
                               sudo: true
    hashes = stdout.lines.grep(/^SHA-256 hash:/) { |l| l.split(":").second.strip }
    hashes.each do |h|
      system_command "/usr/bin/security",
                     args: ["delete-certificate", "-Z", h],
                     sudo: true
    end
  end

  uninstall launchctl: "com.xk72.Charles.ProxyHelper",
            quit:      "com.xk72.Charles",
            delete:    "/Library/PrivilegedHelperTools/com.xk72.Charles.ProxyHelper"

  zap trash: [
    "~/Library/Application Support/Charles",
    "~/Library/Preferences/com.xk72.charles.config",
    "~/Library/Preferences/com.xk72.Charles.plist",
    "~/Library/Saved Application State/com.xk72.Charles.savedState",
  ]

  caveats do
    requires_rosetta
  end
end
