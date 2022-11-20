cask "font-syne" do
  version :latest
  sha256 :no_check

  url "https://ghproxy.com/github.com/google/fonts/raw/main/ofl/syne/Syne%5Bwght%5D.ttf",
      verified: "github.com/google/fonts/"
  name "Syne"
  desc "Typeface originally designed for the art center Synesthésie"
  homepage "https://fonts.google.com/specimen/Syne"

  font "Syne[wght].ttf"
end
