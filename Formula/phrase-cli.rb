class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.6.1.tar.gz"
  sha256 "65288c3742267731bbe3168dd8d3cf6e9866ed86dba6954b52de3240c873aed3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "91d358c8a7ceff50548bd77855cf736526db170ced712827030bb97b55fde7c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c74b94147e32f69410664d95f407ba0470b29ef05d3c381abdf4d33772ee6ce2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4a2c2e5632772c032924bf2531d1bc890178eb80c492ac94e89531c5ac35f9e3"
    sha256 cellar: :any_skip_relocation, ventura:        "198799cd834473b54c53f961776523eaf0a00273151b4cb9f64f6e7ef878c0b8"
    sha256 cellar: :any_skip_relocation, monterey:       "21b415d1f5a0671410dd236874ac901081891199a268fc39186fb619083b7505"
    sha256 cellar: :any_skip_relocation, big_sur:        "090d1cdff4af86e9efa00523be78349ee7ae0a4def9b161775bc88004c2cc697"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7f013463602ec7cad9768b9e36319491ee1beb5a767f4342332273aca53189b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s
      -w
      -X=github.com/phrase/phrase-cli/cmd.PHRASE_CLIENT_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
    bin.install_symlink "phrase-cli" => "phrase"

    generate_completions_from_executable(bin/"phrase", "completion", base_name: "phrase", shells: [:bash])
  end

  test do
    assert_match "ERROR: no targets for download specified", shell_output("#{bin}/phrase pull 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/phrase version")
  end
end
