cask "ripme" do
  version "1.7.95"
  sha256 "008201e406f401b27248277a4188f26203bb9da0170872de900125f8a6c8b558"

  url "https://mirror.ghproxy.com/https://github.com/RipMeApp/ripme/releases/download/#{version}/ripme.jar"
  name "RipMe"
  desc "Album ripper for various websites"
  homepage "https://github.com/RipMeApp/ripme"

  auto_updates true
  container type: :naked

  artifact "ripme.jar", target: "#{appdir}/ripme.jar"

  uninstall delete: "/Applications/rips"

  zap trash: "~/Library/Application Support/ripme"

  caveats do
    depends_on_java "8+"
  end
end
