cask "font-londrina-sketch" do
  version :latest
  sha256 :no_check

  url "https://ghproxy.com/github.com/google/fonts/raw/main/ofl/londrinasketch/LondrinaSketch-Regular.ttf",
      verified: "github.com/google/fonts/"
  name "Londrina Sketch"
  homepage "https://fonts.google.com/specimen/Londrina+Sketch"

  font "LondrinaSketch-Regular.ttf"
end
