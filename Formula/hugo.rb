class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.108.0.tar.gz"
  sha256 "dc90e9de22ce87c22063ce9c309cefacba89269a21eb369ed556b90b22b190c5"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "130e9c38547fe080a8b853a156ba9b822a069979d48bb36c31247890c7ca7d2e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7947fe185db2bf3e2fbbe1919146ac10fa318d5247e8c803cf5f0f79f0741e0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc32d875018527fc63855780692f4509e4f09e99b128a0697465c3e4f53b1bf0"
    sha256 cellar: :any_skip_relocation, ventura:        "dc5e7b466bba95d38e23c69f97f38817560e4b35b3617a81429eb83a5c6c3fd9"
    sha256 cellar: :any_skip_relocation, monterey:       "668f401abc34249b6b3c7abd0bde41000d64640119a883837d8982683134a979"
    sha256 cellar: :any_skip_relocation, big_sur:        "037959e244141794454fb293170d77475ae885e9369b7def256a5cb024d7e429"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa0d606eec4059c2c6030229ceeb94b40456fd9f2b05ad668b48407aac9f3254"
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
