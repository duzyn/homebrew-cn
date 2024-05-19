cask "font-league-mono" do
  version "2.300"
  sha256 "16bdc983aa5eb1803a3c2fbb11d15a8cfa1ce317334a61b01f0f3ab302fdcf0d"

  url "https://github.com/theleagueof/league-mono/releases/download/#{version}/LeagueMono-#{version}.tar.xz",
      verified: "github.com/theleagueof/league-mono/"
  name "League Mono"
  desc "Monospace typeface inspired by Fira Mono, Libertinus Mono, and Courier"
  homepage "https://www.theleagueofmoveabletype.com/league-mono"

  font "LeagueMono-#{version}/static/OTF/LeagueMono-Thin.otf"
  font "LeagueMono-#{version}/static/OTF/LeagueMono-UltraLight.otf"
  font "LeagueMono-#{version}/static/OTF/LeagueMono-Light.otf"
  font "LeagueMono-#{version}/static/OTF/LeagueMono-Regular.otf"
  font "LeagueMono-#{version}/static/OTF/LeagueMono-Medium.otf"
  font "LeagueMono-#{version}/static/OTF/LeagueMono-SemiBold.otf"
  font "LeagueMono-#{version}/static/OTF/LeagueMono-Bold.otf"
  font "LeagueMono-#{version}/static/OTF/LeagueMono-ExtraBold.otf"
  font "LeagueMono-#{version}/static/OTF/LeagueMono-CondensedThin.otf"
  font "LeagueMono-#{version}/static/OTF/LeagueMono-CondensedUltraLight.otf"
  font "LeagueMono-#{version}/static/OTF/LeagueMono-CondensedLight.otf"
  font "LeagueMono-#{version}/static/OTF/LeagueMono-Condensed.otf"
  font "LeagueMono-#{version}/static/OTF/LeagueMono-CondensedMedium.otf"
  font "LeagueMono-#{version}/static/OTF/LeagueMono-CondensedSemiBold.otf"
  font "LeagueMono-#{version}/static/OTF/LeagueMono-CondensedBold.otf"
  font "LeagueMono-#{version}/static/OTF/LeagueMono-CondensedExtraBold.otf"
  font "LeagueMono-#{version}/static/OTF/LeagueMono-ExtendedThin.otf"
  font "LeagueMono-#{version}/static/OTF/LeagueMono-ExtendedUltraLight.otf"
  font "LeagueMono-#{version}/static/OTF/LeagueMono-ExtendedLight.otf"
  font "LeagueMono-#{version}/static/OTF/LeagueMono-ExtendedMedium.otf"
  font "LeagueMono-#{version}/static/OTF/LeagueMono-ExtendedRegular.otf"
  font "LeagueMono-#{version}/static/OTF/LeagueMono-ExtendedSemiBold.otf"
  font "LeagueMono-#{version}/static/OTF/LeagueMono-ExtendedBold.otf"
  font "LeagueMono-#{version}/static/OTF/LeagueMono-ExtendedExtraBold.otf"
  font "LeagueMono-#{version}/static/OTF/LeagueMono-NarrowThin.otf"
  font "LeagueMono-#{version}/static/OTF/LeagueMono-NarrowUltraLight.otf"
  font "LeagueMono-#{version}/static/OTF/LeagueMono-NarrowLight.otf"
  font "LeagueMono-#{version}/static/OTF/LeagueMono-NarrowMedium.otf"
  font "LeagueMono-#{version}/static/OTF/LeagueMono-NarrowRegular.otf"
  font "LeagueMono-#{version}/static/OTF/LeagueMono-NarrowSemiBold.otf"
  font "LeagueMono-#{version}/static/OTF/LeagueMono-NarrowBold.otf"
  font "LeagueMono-#{version}/static/OTF/LeagueMono-NarrowExtraBold.otf"
  font "LeagueMono-#{version}/static/OTF/LeagueMono-WideThin.otf"
  font "LeagueMono-#{version}/static/OTF/LeagueMono-WideUltraLight.otf"
  font "LeagueMono-#{version}/static/OTF/LeagueMono-WideLight.otf"
  font "LeagueMono-#{version}/static/OTF/LeagueMono-WideMedium.otf"
  font "LeagueMono-#{version}/static/OTF/LeagueMono-WideRegular.otf"
  font "LeagueMono-#{version}/static/OTF/LeagueMono-WideSemiBold.otf"
  font "LeagueMono-#{version}/static/OTF/LeagueMono-WideBold.otf"
  font "LeagueMono-#{version}/static/OTF/LeagueMono-WideExtraBold.otf"
  font "LeagueMono-#{version}/variable/TTF/LeagueMono-VF.ttf"

  # No zap stanza required
end