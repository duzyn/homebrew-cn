cask "wireshark-chmodbpf" do
  arch arm: "Arm", intel: "Intel"

  version "4.4.4"
  sha256 arm:   "24cdce2f5869653b98032e8f6f06a08bd4f4899f178a27eb6d751fc27ac9cb47",
         intel: "46b267bdd78222aa272937a65fa91b09c3755bc0ec01fa52e8b63984699c0afb"

  url "https://mirror.nju.edu.cn/wireshark//osx/Wireshark%20#{version}%20#{arch}%2064.dmg"
  name "Wireshark-ChmodBPF"
  desc "Network protocol analyzer"
  homepage "https://www.wireshark.org/"

  livecheck do
    cask "wireshark"
  end

  conflicts_with cask: "wireshark"
  depends_on macos: ">= :sierra"

  pkg "Install ChmodBPF.pkg"

  uninstall early_script: {
              executable:   "/usr/sbin/installer",
              args:         ["-pkg", "#{staged_path}/Uninstall ChmodBPF.pkg", "-target", "/"],
              sudo:         true,
              must_succeed: false,
            },
            pkgutil:      "org.wireshark.ChmodBPF.pkg"

  # No zap stanza required

  caveats do
    reboot
    <<~EOS
      This cask will install only the ChmodBPF package from the current Wireshark
      stable install package.
      An access_bpf group will be created and its members allowed access to BPF
      devices at boot to allow unprivileged packet captures.
      This cask is not required if installing the Wireshark cask. It is meant to
      support Wireshark installed from Homebrew or other cases where unprivileged
      access to macOS packet capture devices is desired without installing the binary
      distribution of Wireshark.
      The user account used to install this cask will be added to the access_bpf
      group automatically.
    EOS
  end
end
