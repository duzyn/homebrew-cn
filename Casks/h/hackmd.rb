cask "hackmd" do
  version "0.1.0"
  sha256 "681051aa8a89ce2f3a0b2c374fa8d3d6dbf43be7464307749ff029df7c4eed7a"

  url "https://mirror.ghproxy.com/https://github.com/hackmdio/hackmd-desktop/releases/download/v#{version}/HackMD-#{version}.dmg"
  name "HackMD"
  desc "Desktop Software for HackMD Note-Taking and Collaboration"
  homepage "https://github.com/hackmdio/hackmd-desktop"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-07-17", because: :unmaintained
  disable! date: "2025-07-17", because: :unmaintained

  app "HackMD.app"

  zap trash: [
    "~/Library/Application Support/HackMD",
    "~/Library/Saved Application State/com.hackmd.desktop.savedState",
  ]

  caveats do
    requires_rosetta
  end
end
