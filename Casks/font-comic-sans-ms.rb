cask "font-comic-sans-ms" do
  version "2.10"
  sha256 :no_check

  url "https://downloads.sourceforge.net/corefonts/comic32.exe?use_mirror=nchc"
  appcast "https://sourceforge.net/projects/corefonts/rss"
  name "Comic Sans"
  homepage "https://sourceforge.net/projects/corefonts/files/the%20fonts/final/"

  font "Comicbd.TTF"
  font "Comic.TTF"
end
