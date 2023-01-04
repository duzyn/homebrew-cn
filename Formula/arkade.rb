class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.8.54",
      revision: "032001c3b18f9acb92bc5bf133f03718b8d5cc98"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d9dd3e5a1e9eaea78efa2aa13d9ec10f2fc31832a3bd5dbc77897d5acf093ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7894cf1353ca41cffd023f703aa1ee778aefbdf52e90733d455a7539b47977f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f6b1be8095cf5200caed55eab1bd5b870465f79cdc5881f954ac5bf610f37536"
    sha256 cellar: :any_skip_relocation, ventura:        "95d3131112ec636529ad9284eda27d714c0c617410797d62faa59f128d42bf97"
    sha256 cellar: :any_skip_relocation, monterey:       "869a7be252cdcb105d648d21a3bc83b2e9f64ebf68a312ba3624ad040baef11e"
    sha256 cellar: :any_skip_relocation, big_sur:        "322babe5ea218cb8bd445b1a64029cf98a3c80e175b5ff5c0513b684ae534fcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ebafb4235a429b819576f471a66566d62915f59e3c061e9cb7a39b3e241c766"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/alexellis/arkade/cmd.Version=#{version}
      -X github.com/alexellis/arkade/cmd.GitCommit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bin.install_symlink "arkade" => "ark"

    generate_completions_from_executable(bin/"arkade", "completion")
    # make zsh completion also work for `ark` symlink
    inreplace zsh_completion/"_arkade", "#compdef arkade", "#compdef arkade ark=arkade"
  end

  test do
    assert_match "Version: #{version}", shell_output(bin/"arkade version")
    assert_match "Info for app: openfaas", shell_output(bin/"arkade info openfaas")
  end
end
