class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://mirror.ghproxy.com/https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.78.1.tar.gz"
  sha256 "382fa2b6047c173fe30cd86b95cb6d24e2795afc0de87d8600a1e74d065cda11"
  license "Apache-2.0"
  head "https://github.com/jfrog/jfrog-cli.git", branch: "v2"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9cfb2e73f972355b7a72dcff946bdb71e47c955e06604ae59e2f723622294ca8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9cfb2e73f972355b7a72dcff946bdb71e47c955e06604ae59e2f723622294ca8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9cfb2e73f972355b7a72dcff946bdb71e47c955e06604ae59e2f723622294ca8"
    sha256 cellar: :any_skip_relocation, sonoma:        "91216309801dce8ac5b682d9006110c7c0455ab8e4fe6cc039695ffa26dd4fbc"
    sha256 cellar: :any_skip_relocation, ventura:       "db10059ee602ac896f5da0846d2b5eafaae160e998150966d0d3ed95bf349f63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9b64631ac8c1267897271e7b77e373590f28c891523ea98a24878ae9e88d5b5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"jf")
    bin.install_symlink "jf" => "jfrog"

    generate_completions_from_executable(bin/"jf", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jf -v")
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
    with_env(JFROG_CLI_REPORT_USAGE: "false", CI: "true") do
      assert_match "build name must be provided in order to generate build-info",
        shell_output("#{bin}/jf rt bp --dry-run --url=http://127.0.0.1 2>&1", 1)
    end
  end
end
