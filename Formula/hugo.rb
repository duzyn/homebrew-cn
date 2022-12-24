class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.109.0.tar.gz"
  sha256 "35a5ba92057fe2c20b2218c374e762887021e978511d19bbe81ce4d9c21f0c78"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1cad3979e8ac3e06774793a251ef13451cef579028d3c18aea9c4d7cfe517c24"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "178bcfdc98efb6432da3ae5d2e25a40eb71cd1e4cee12968d4b99faf3455fbcf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "237ec9456767fa209adddde4e7f2326c6cc5b94f93c09c37c2017cab983b4a62"
    sha256 cellar: :any_skip_relocation, ventura:        "231e16b45ba018f64fa82dd1f79c5ddca46bf563b4c7641555a391cababcff67"
    sha256 cellar: :any_skip_relocation, monterey:       "d0603fd20fb638b0412282e95e8a2dec0fe4829799b248de9290362e3e102982"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee8c8a814e739e0cfe935980e2e2b9342bcf23d876f5569fbadc0ddd7453be67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d40bbd55d21128928fcc9a4767ed2b2fad2b73ccde9c9f27e42ae991972a29af"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-tags", "extended"

    generate_completions_from_executable(bin/"hugo", "completion")

    # Build man pages; target dir man/ is hardcoded :(
    (Pathname.pwd/"man").mkpath
    system bin/"hugo", "gen", "man"
    man1.install Dir["man/*.1"]
  end

  test do
    site = testpath/"hops-yeast-malt-water"
    system "#{bin}/hugo", "new", "site", site
    assert_predicate testpath/"#{site}/config.toml", :exist?
  end
end
