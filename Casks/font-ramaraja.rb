cask "font-ramaraja" do
  version :latest
  sha256 :no_check

  url "https://ghproxy.com/github.com/google/fonts/raw/main/ofl/ramaraja/Ramaraja-Regular.ttf",
      verified: "github.com/google/fonts/"
  name "Ramaraja"
  homepage "https://fonts.google.com/specimen/Ramaraja"

  font "Ramaraja-Regular.ttf"
end
