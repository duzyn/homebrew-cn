class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/v2.22.2.tar.gz"
  sha256 "84871d898cf25cbcdccbbe3ca7f68e11a3de89a34eb3b5212091ae73ad207ba5"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6996d9175434931d063f8788fc4bcb08e0ada4ad51ade993e48d98517b63a852"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1674a001e6206f7a9d1666705201fc661f29b26ba6bec034533bec9132f434f5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "87c91c220c86c4638ff74589806192a1cafb30d73803f5330ba12e0cfc76458c"
    sha256 cellar: :any_skip_relocation, ventura:        "b1989d3eaa5205ff70e2c92d5acefcb7272ed843c06c233418d101a2adf7a0be"
    sha256 cellar: :any_skip_relocation, monterey:       "9b94f82ebef58cc0cfe9ae55fb733ee6549e8af2706a25a1c4884402733ab7b9"
    sha256 cellar: :any_skip_relocation, big_sur:        "9549bdc28c0e954648c396f2d7fb547fa43f9076572d86a3869f6872ef64dcda"
    sha256 cellar: :any_skip_relocation, catalina:       "07ba6410d7d95cea2652fa9f48d53ff3c3978b85283db07ee79c04e6c49d4cc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "204b6177fdf4c3bd0547e07daf863027c7db32ddbd2a2c18507ced0f4fe40d1b"
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
