cask "font-iosevka-ss06" do
  version "32.3.0"
  sha256 "6743d645909b289351b8c748b84620bf8c212b10d5c69d23265185156e0416b2"

  url "https://github.com/be5invis/Iosevka/releases/download/v#{version}/SuperTTC-IosevkaSS06-#{version}.zip"
  name "Iosevka SS06"
  homepage "https://github.com/be5invis/Iosevka/"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS06.ttc"

  # No zap stanza required
end
