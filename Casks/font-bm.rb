cask "font-bm" do
  version :latest
  sha256 :no_check

  url "https://ghproxy.com/github.com/google/fonts/raw/main/ofl/hanna/BM-HANNA.ttf",
      verified: "github.com/google/fonts/"
  name "BM"
  homepage "https://fonts.google.com/earlyaccess"

  font "BM-HANNA.ttf"
end
