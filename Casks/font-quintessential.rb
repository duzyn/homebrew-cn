cask "font-quintessential" do
  version :latest
  sha256 :no_check

  url "https://ghproxy.com/github.com/google/fonts/raw/main/ofl/quintessential/Quintessential-Regular.ttf",
      verified: "github.com/google/fonts/"
  name "Quintessential"
  homepage "https://fonts.google.com/specimen/Quintessential"

  font "Quintessential-Regular.ttf"
end
