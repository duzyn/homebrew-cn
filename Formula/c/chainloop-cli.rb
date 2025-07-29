class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://mirror.ghproxy.com/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.37.0.tar.gz"
  sha256 "51b35adeb4637b829bc8597d528526411ad91b95b1db5121088e0a26c43618e2"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f42cf31100aa6050780dc5c9e27e73d4fa5a8628494e9e459bbe786957bae9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb0707e454035d5f6aea0e3a0731c7cbb0948aaa6e98c032a200d7ca245bfb40"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0152b455ebc197014d9c65ec4012d6b705d27497e196611f46ecb510fbcc9cf7"
    sha256 cellar: :any_skip_relocation, sonoma:        "eac75bce8d9b10406bd4277fe92333be7b2241072fa76db87d5e252237d1faee"
    sha256 cellar: :any_skip_relocation, ventura:       "7538dd03afc3c5a6c9e6065c95b2c0b53dbc351d45c6f1f494673b3c60b98b8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50166ec1e32d7f4db1c5c16dc26336d02cd771d56a923cf688dfc2b1764a16da"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end
