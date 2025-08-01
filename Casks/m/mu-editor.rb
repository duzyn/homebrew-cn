cask "mu-editor" do
  version "1.2.0"
  sha256 "306bef4ebfafd1dcf928bc260d5d57e64efbccb537b27f5818a9fc12437726b6"

  url "https://mirror.ghproxy.com/https://github.com/mu-editor/mu/releases/download/v#{version}/MuEditor-osx-#{version}.dmg",
      verified: "github.com/mu-editor/mu/"
  name "Mu"
  desc "Small, simple editor for beginner Python programmers"
  homepage "https://codewith.mu/"

  no_autobump! because: :requires_manual_review

  app "Mu Editor.app"

  zap trash: [
        "~/Library/Application Support/mu",
        "~/Library/Logs/mu",
      ],
      rmdir: "~/mu_code"

  caveats do
    requires_rosetta
  end
end
