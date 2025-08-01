cask "flame" do
  version "3.0.0,80"
  sha256 "cc09216769022fc4acb20eaddd37898ace0d3a9ca8d9f53fbc06cdbfd45868e0"

  # Tag version format is 1.2.3(45) but zip file uses 1.2.3.45
  url "https://mirror.ghproxy.com/https://github.com/tominsam/flametouch/releases/download/#{version.csv.first}(#{version.csv.second})/Flame.#{version.csv.first}.#{version.csv.second}.zip",
      verified: "github.com/tominsam/flametouch/"
  name "Flame"
  desc "Rendezvous service browser for iPhone / iPod touch"
  homepage "https://movieos.org/code/flame/"

  livecheck do
    url :url
    regex(/^v?(\d+(?:\.\d+)+)(?:\((\d+)\))?$/i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map do |match|
        match[1].present? ? "#{match[0]},#{match[1]}" : match[0]
      end
    end
  end

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :big_sur"

  app "Flame.app"
end
