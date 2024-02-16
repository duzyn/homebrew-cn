cask "toinane-colorpicker" do
  version "2.2.0"
  sha256 "9fbe263bb81b9814ff583515195adf94bab926c76141a119b173c0fffc8588b4"

  url "https://mirror.ghproxy.com/https://github.com/toinane/colorpicker/releases/download/#{version}/Colorpicker-#{version}.dmg",
      verified: "github.com/toinane/colorpicker/"
  name "Colorpicker"
  desc "Get and save colour codes"
  homepage "https://colorpicker.fr/"

  app "Colorpicker.app"

  zap trash: "~/Library/Application Support/Colorpicker"
end
