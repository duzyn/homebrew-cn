class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.60.1",
    revision: "e9e36317129875443314338a5250a4c9ede605c0"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "591bd692d57a0ff8eb2181e4d3623c5222bbf4c7124153412023fd38c9685956"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7cd7bfbef6f042282310b3da0620f1670615f6f9a1437fc3aabad58a06e999c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f68816f90293cf6998d432acc01599953dcb409e2b44c6e476ff314743dd4707"
    sha256 cellar: :any_skip_relocation, ventura:        "3b354de799bf3eec08306f933378e9c4211559ccffe7b5145ba027fe3f2d5fcd"
    sha256 cellar: :any_skip_relocation, monterey:       "8f4d30b79964a179ed2b07a8f97acb9a6cc2efac1288f1111538e1f106d271eb"
    sha256 cellar: :any_skip_relocation, big_sur:        "10006f16945b40667f4a21823c89a6a7e18a25a79149ae5c326dac3bea3fba4b"
    sha256 cellar: :any_skip_relocation, catalina:       "920b3667baabd3a8be3d82abecbea770f2bbc04f4eab251242ebced104a8327e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "101eb68949efff576dcdc63adfe31d4e45bf21026e19d5bce4bce6005503f955"
  end

  depends_on "go" => :build

  def install
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    ldflags = %W[
      -s -w
      -X github.com/wakatime/wakatime-cli/pkg/version.Arch=#{arch}
      -X github.com/wakatime/wakatime-cli/pkg/version.BuildDate=#{time.iso8601}
      -X github.com/wakatime/wakatime-cli/pkg/version.Commit=#{Utils.git_head(length: 7)}
      -X github.com/wakatime/wakatime-cli/pkg/version.OS=#{OS.kernel_name.downcase}
      -X github.com/wakatime/wakatime-cli/pkg/version.Version=v#{version}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    output = shell_output("#{bin}/wakatime-cli --help 2>&1")
    assert_match "Command line interface used by all WakaTime text editor plugins", output
  end
end
