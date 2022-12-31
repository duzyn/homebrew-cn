class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/v2.23.0.tar.gz"
  sha256 "57ff3663323aea2aca8f5606b19b8a8d88153d8f6bf43da41164e7459993b007"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "92044c03793e85e2e9ae986bd5af556df933ae4263aa69e7dbdbf75e71ea6c27"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "afbe066836874ff5cf6451706633f9e77003b4349a8c9e34b6954d1e0cc30355"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b27aaea33c0bf7ede18e6991503a40cb2175dd95b0fb1f32345d42387f7048c8"
    sha256 cellar: :any_skip_relocation, ventura:        "e70ec829b0d2a6a95af6ecbb63ac4d345f1f5acda7ee3fdc17c5932e48338374"
    sha256 cellar: :any_skip_relocation, monterey:       "5543a8ce5209e28544b891e6e8f15c8df09aa981f656c879adce7f503788c155"
    sha256 cellar: :any_skip_relocation, big_sur:        "910955de3e71a49cf9780d7133f67ea10c7436908bf44f7cdea2a18fe598b702"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3fb89e43ee1c5ffa60386a6c0583b2fdb427538fafa8487644217bdb329366d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=v#{version}"), "./cmd/nfpm"

    generate_completions_from_executable(bin/"nfpm", "completion")
  end

  test do
    assert_match version.to_s,
      shell_output("#{bin}/nfpm --version 2>&1")

    system bin/"nfpm", "init"
    assert_match "nfpm example config file", File.read(testpath/"nfpm.yaml")

    # remove the generated default one
    # and use stubbed one for another test
    File.delete(testpath/"nfpm.yaml")
    (testpath/"nfpm.yaml").write <<~EOS
      name: "foo"
      arch: "amd64"
      platform: "linux"
      version: "v1.0.0"
      section: "default"
      priority: "extra"
    EOS

    system bin/"nfpm", "pkg", "--packager", "deb", "--target", "."
    assert_predicate testpath/"foo_1.0.0_amd64.deb", :exist?
  end
end
