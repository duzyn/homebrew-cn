cask "font-aclonica" do
  version :latest
  sha256 :no_check

  url "https://ghproxy.com/github.com/google/fonts/raw/main/apache/aclonica/Aclonica-Regular.ttf",
      verified: "github.com/google/fonts/"
  name "Aclonica"
  homepage "https://fonts.google.com/specimen/Aclonica"

  font "Aclonica-Regular.ttf"
end
