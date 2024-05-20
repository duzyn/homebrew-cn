cask "karabiner-elements" do
  on_el_capitan :or_older do
    version "11.6.0"
    sha256 "c1b06252ecc42cdd8051eb3d606050ee47b04532629293245ffdfa01bbc2430d"

    url "https://mirror.ghproxy.com/https://github.com/pqrs-org/Karabiner-Elements/releases/download/v#{version}/Karabiner-Elements-#{version}.dmg",
        verified: "github.com/pqrs-org/Karabiner-Elements/"

    livecheck do
      skip "Legacy version"
    end

    depends_on macos: ">= :el_capitan"

    pkg "Karabiner-Elements.sparkle_guided.pkg"
  end
  on_sierra do
    version "12.10.0"
    sha256 "53252f7d07e44f04972afea2a16ac595552c28715aa65ff4a481a1c18c8be2f4"

    url "https://mirror.ghproxy.com/https://github.com/pqrs-org/Karabiner-Elements/releases/download/v#{version}/Karabiner-Elements-#{version}.dmg",
        verified: "github.com/pqrs-org/Karabiner-Elements/"

    livecheck do
      skip "Legacy version"
    end

    pkg "Karabiner-Elements.sparkle_guided.pkg"
  end
  on_high_sierra do
    version "12.10.0"
    sha256 "53252f7d07e44f04972afea2a16ac595552c28715aa65ff4a481a1c18c8be2f4"

    url "https://mirror.ghproxy.com/https://github.com/pqrs-org/Karabiner-Elements/releases/download/v#{version}/Karabiner-Elements-#{version}.dmg",
        verified: "github.com/pqrs-org/Karabiner-Elements/"

    livecheck do
      skip "Legacy version"
    end

    pkg "Karabiner-Elements.sparkle_guided.pkg"
  end
  on_mojave :or_older do
    uninstall launchctl: [
                "org.pqrs.karabiner.agent.karabiner_grabber",
                "org.pqrs.karabiner.agent.karabiner_observer",
                "org.pqrs.karabiner.karabiner_console_user_server",
                "org.pqrs.karabiner.karabiner_kextd",
                "org.pqrs.karabiner.karabiner_session_monitor",
              ],
              signal:    [
                ["TERM", "org.pqrs.Karabiner-Menu"],
                ["TERM", "org.pqrs.Karabiner-NotificationWindow"],
              ],
              script:    {
                executable: "/Library/Application Support/org.pqrs/Karabiner-Elements/uninstall_core.sh",
                sudo:       true,
              },
              pkgutil:   "org.pqrs.Karabiner-Elements",
              delete:    "/Library/Application Support/org.pqrs/"
  end
  on_mojave do
    version "12.10.0"
    sha256 "53252f7d07e44f04972afea2a16ac595552c28715aa65ff4a481a1c18c8be2f4"

    url "https://mirror.ghproxy.com/https://github.com/pqrs-org/Karabiner-Elements/releases/download/v#{version}/Karabiner-Elements-#{version}.dmg",
        verified: "github.com/pqrs-org/Karabiner-Elements/"

    livecheck do
      skip "Legacy version"
    end

    pkg "Karabiner-Elements.sparkle_guided.pkg"
  end
  on_catalina do
    version "13.7.0"
    sha256 "9ac5e53a71f3a00d7bdb2f5f5f001f70b6b8b7b2680e10a929e0e4c488c8734b"

    url "https://mirror.ghproxy.com/https://github.com/pqrs-org/Karabiner-Elements/releases/download/v#{version}/Karabiner-Elements-#{version}.dmg",
        verified: "github.com/pqrs-org/Karabiner-Elements/"

    livecheck do
      skip "Legacy version"
    end

    pkg "Karabiner-Elements.pkg"
  end
  on_catalina :or_newer do
    uninstall early_script: {
                executable: "/Library/Application Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice/scripts/uninstall/remove_files.sh",
                sudo:       true,
              },
              launchctl:    [
                "org.pqrs.karabiner.agent.karabiner_grabber",
                "org.pqrs.karabiner.agent.karabiner_observer",
                "org.pqrs.karabiner.karabiner_console_user_server",
                "org.pqrs.karabiner.karabiner_grabber",
                "org.pqrs.karabiner.karabiner_observer",
                "org.pqrs.karabiner.karabiner_session_monitor",
                "org.pqrs.karabiner.NotificationWindow",
              ],
              signal:       [
                ["TERM", "org.pqrs.Karabiner-Menu"],
                ["TERM", "org.pqrs.Karabiner-NotificationWindow"],
              ],
              script:       {
                executable: "/Library/Application Support/org.pqrs/Karabiner-Elements/uninstall_core.sh",
                sudo:       true,
              },
              pkgutil:      [
                "org.pqrs.Karabiner-DriverKit-VirtualHIDDevice",
                "org.pqrs.Karabiner-Elements",
              ],
              delete:       "/Library/Application Support/org.pqrs/"
    # The system extension 'org.pqrs.Karabiner-DriverKit-VirtualHIDDevice*' should not be uninstalled by Cask
  end
  on_big_sur :or_newer do
    version "14.13.0"
    sha256 "826270a21b7f4df9b9a8c79c9aad4de8f48021f58eaacbee1d4f150c963c6cbc"

    url "https://mirror.ghproxy.com/https://github.com/pqrs-org/Karabiner-Elements/releases/download/v#{version}/Karabiner-Elements-#{version}.dmg",
        verified: "github.com/pqrs-org/Karabiner-Elements/"

    livecheck do
      url "https://appcast.pqrs.org/karabiner-elements-appcast.xml"
      strategy :sparkle
    end

    depends_on macos: ">= :big_sur"

    pkg "Karabiner-Elements.pkg"
  end

  name "Karabiner Elements"
  desc "Keyboard customiser"
  homepage "https://karabiner-elements.pqrs.org/"

  auto_updates true

  binary "/Library/Application Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli"

  zap trash: [
    "~/.config/karabiner",
    "~/.local/share/karabiner",
    "~/Library/Application Scripts/org.pqrs.Karabiner-VirtualHIDDevice-Manager",
    "~/Library/Application Support/Karabiner-Elements",
    "~/Library/Caches/org.pqrs.Karabiner-Elements.Updater",
    "~/Library/Containers/org.pqrs.Karabiner-VirtualHIDDevice-Manager",
    "~/Library/HTTPStorages/org.pqrs.Karabiner-Elements.Settings",
    "~/Library/Preferences/org.pqrs.Karabiner-Elements.Updater.plist",
  ]
end
