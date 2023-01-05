class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.32.0.tar.gz"
  sha256 "54148a471f71f6f81cabf7054bd6b29c5642577296bad2c4784a2021694da04d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "057bc1f997a9600dffb6a4179bd206f8fc439c109b86d9e0e7004699f03b0865"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48b98fe5186f07f385c463fe93d5e39cd290d6a7a866fb81e17f70156ea87453"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b12a81f0f29c15494a339523b43637b674ab98fda414dc4685680f7b21924d3e"
    sha256 cellar: :any_skip_relocation, ventura:        "9f0a10eac77c3974c8895f786a3c9b09d79876592aff2e6d5d9bf36f81417325"
    sha256 cellar: :any_skip_relocation, monterey:       "22265cc580d9381c756cd9e7630073676ed687945ecd5071dc50debde220f6e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "865c097a652ab3e51374d4018441339115a5d72f399a914b25bb728ba3ef5b6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f60f69673014675297dd09668262e63d475eac1b8e77cb0477453a6ba2d0474e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"jf")
    bin.install_symlink "jf" => "jfrog"

    generate_completions_from_executable(bin/"jf", "completion", base_name: "jf")
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
