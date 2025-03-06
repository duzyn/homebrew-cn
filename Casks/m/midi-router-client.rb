cask "midi-router-client" do
  version "2.0.1"
  sha256 "1fe496db0b6582f8af434df3aae6f7f3bee414076977045ccc912d198201708b"

  url "https://downloads.sourceforge.net/midi-router-client/midi-router-client-#{version}-Darwin.dmg?use_mirror=jaist"
  name "Midi Router Client"
  desc "Create routes from anywhere to anywhere"
  homepage "https://sourceforge.net/projects/midi-router-client/"

  app "midi-router-client.app"

  zap trash: [
    "~/Library/Application Support/Midi router client",
    "~/Library/Caches/midi-router-client",
    "~/Library/Preferences/com.electron.midi-router-client.helper.plist",
    "~/Library/Preferences/com.electron.midi-router-client.plist",
    "~/Library/Preferences/com.shemeshg.MidiRouter.plist",
    "~/Library/Preferences/com.shemeshg.midirouterclient.midi-router-client.plist",
  ]
end
