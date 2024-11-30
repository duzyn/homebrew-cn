class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://mirror.ghproxy.com/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.134.0.tar.gz"
  sha256 "a990342c02e6a3d340cb03096fc9569065f043b69cd11e2af605348032325d9c"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49839afe78e51113e88b113c55cae102573a0519c97e48ba861652487756a411"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49839afe78e51113e88b113c55cae102573a0519c97e48ba861652487756a411"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "49839afe78e51113e88b113c55cae102573a0519c97e48ba861652487756a411"
    sha256 cellar: :any_skip_relocation, sonoma:        "43a280c1665c6b91e94955329bffd3ca6d597c2938b70c9a8c26440c1429e983"
    sha256 cellar: :any_skip_relocation, ventura:       "bbf6f7ac57d529db8c8de7fbc462a65965303c98162aa28c99e599189d8e32a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f863d2070423640010e6b967e0ddcede70d95aa16eabc45d7a41d852260d37b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", "completion", base_name: "chainloop")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end
