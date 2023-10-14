cask "tigervnc-viewer" do
  version "1.13.1"
  sha256 "d823197320e6903458f9039cb9d4dbf5d739ef7f9c18ccabfb68bc3fffe57b9d"

  url "https://downloads.sourceforge.net/tigervnc/TigerVNC-#{version}.dmg?use_mirror=nchc",
      verified: "downloads.sourceforge.net/tigervnc/?use_mirror=nchc"
  name "TigerVNC"
  desc "Multi-platform VNC client and server"
  homepage "https://tigervnc.org/"

  livecheck do
    url "https://github.com/TigerVNC/tigervnc"
    strategy :github_latest
  end

  app "TigerVNC Viewer #{version}.app"

  zap trash: "~/Library/Saved Application State/com.tigervnc.tigervnc.savedState"
end