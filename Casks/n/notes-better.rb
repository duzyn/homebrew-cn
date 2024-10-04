cask "notes-better" do
  version "2.3.1"
  sha256 "c89fde7f77137c3d19170191c775b3ce097021d3d74741429d166b7f9686e272"

  url "https://mirror.ghproxy.com/https://github.com/nuttyartist/notes/releases/download/v#{version}/Notes.#{version}.dmg",
      verified: "github.com/nuttyartist/notes/"
  name "Notes"
  desc "Simple note-taking app for markdown and kanban"
  homepage "https://get-notes.com/"

  depends_on macos: ">= :catalina"

  app "Notes Better.app"

  zap trash: [
    "~/Library/Caches/Notes",
    "~/Library/Preferences/io.github.nuttyartist.notes.plist",
    "~/Library/Saved Application State/io.github.nuttyartist.notes.savedState",
  ]
end
