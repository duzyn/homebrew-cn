class Kics < Formula
  desc "Detect vulnerabilities, compliance issues, and misconfigurations"
  homepage "https://kics.io/"
  url "https://github.com/Checkmarx/kics/archive/refs/tags/v1.6.7.tar.gz"
  sha256 "7163b06fdae0b6c4646ab2926b99527fd293231271551c743445fbebfb4d24f0"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/kics.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d344e0118b2414b1232149d5aaa356520dbff777bb1c0f9817ee06e3c66a976"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4b7e4b66c273191e743825df449424d4dcb41bc23fe25581fff67525e594d22"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4671cc061246c98d2c6f9789ee929eb7c45589a9b5e3addc49d8c10d3028cda0"
    sha256 cellar: :any_skip_relocation, ventura:        "92af1ec98df25ef5fe6606e542ae2fec2c1bfc49131326a17421789d93181f10"
    sha256 cellar: :any_skip_relocation, monterey:       "3ce1652215a1ab00d61f6ef8b1138e70c488844de65d8d38fa3ab53b8fe302c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "7cb8e73ff6ec3e342dcec8f59ed378ded8fef0bd3d188b71c82762b40a1d07a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa31422d038b35a753ec843bab64f707e514e5255789897f3cfc21b3a6088dcf"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Checkmarx/kics/internal/constants.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/console"

    pkgshare.install "assets"
  end

  def caveats
    <<~EOS
      KICS queries are placed under #{opt_pkgshare}/assets/queries
      To use KICS default queries add KICS_QUERIES_PATH env to your ~/.zshrc or ~/.zprofile:
          "echo 'export KICS_QUERIES_PATH=#{opt_pkgshare}/assets/queries' >> ~/.zshrc"
      usage of CLI flag --queries-path takes precedence.
    EOS
  end

  test do
    ENV["KICS_QUERIES_PATH"] = pkgshare/"assets/queries"
    ENV["DISABLE_CRASH_REPORT"] = "0"

    assert_match "Files scanned: 0", shell_output("#{bin}/kics scan -p #{testpath}")
    assert_match version.to_s, shell_output("#{bin}/kics version")
  end
end
