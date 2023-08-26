class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.30.0",
      revision: "7d3c5a2f73bb035968abbf4c11126f40b4f43391"
  license "Apache-2.0"
  head "https://github.com/lacework/go-sdk.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "619d20d8608a2a3ff96ec809c91a8a6615341441ef1bb687775f10e8cc15a520"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ee64b5020328c3833ec78b3a8a9bc32cc8ffc9660cab8bea263e4d63d6e3e84"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "039b6961c5fe1d042e61340fccefeddf6303bb99e72b0885654e9578b94eccc8"
    sha256 cellar: :any_skip_relocation, ventura:        "b0b4bae4e4d1c2d4ee89ba019e9b5401d838a6a45d0a8c944e6a909934aa9c1c"
    sha256 cellar: :any_skip_relocation, monterey:       "2cd7d63d7e1ba009b8117421a02f4db0425341f7125f1310eef0030e798a1f8c"
    sha256 cellar: :any_skip_relocation, big_sur:        "78ec25733aafb670634a798cb5422f44bd4b4bf2d949d92c9d3490f8083b8beb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6efa5fa40db555e3ee358aa7d4f89b9145c6d006803ca437a33f5282087a500a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/lacework/go-sdk/cli/cmd.Version=#{version}
      -X github.com/lacework/go-sdk/cli/cmd.GitSHA=#{Utils.git_head}
      -X github.com/lacework/go-sdk/cli/cmd.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(output: bin/"lacework", ldflags: ldflags), "./cli"

    generate_completions_from_executable(bin/"lacework", "completion", base_name: "lacework")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lacework version")

    output = shell_output("#{bin}/lacework configure list 2>&1", 1)
    assert_match "ERROR unable to load profiles. No configuration file found.", output
  end
end
