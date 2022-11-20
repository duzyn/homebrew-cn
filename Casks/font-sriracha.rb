cask "font-sriracha" do
  version :latest
  sha256 :no_check

  url "https://ghproxy.com/github.com/google/fonts/raw/main/ofl/sriracha/Sriracha-Regular.ttf",
      verified: "github.com/google/fonts/"
  name "Sriracha"
  homepage "https://fonts.google.com/specimen/Sriracha"

  font "Sriracha-Regular.ttf"
end
