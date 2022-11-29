class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.59.0",
    revision: "b42ad3c9402df7443ad3c41e378a3e02df121e65"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c13576274f21aebe82fffeb20de259986410f705b5aa8176b0096530d3807e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6449981579706dc82263458ba95f3541281644aff701bae2b233986f27e0bb76"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1c8abf61ba2b36939bd7dc63a0741e8acaeba718c24be722bc7b9368469f59dc"
    sha256 cellar: :any_skip_relocation, ventura:        "e1e6a7dc970276d61db23cabcec345a1433891f7116cd35e75285d39f3570245"
    sha256 cellar: :any_skip_relocation, monterey:       "793621ec9d534cdfd760af266017dd28acd6b3847eefeb86bd46b6f5fa09bc56"
    sha256 cellar: :any_skip_relocation, big_sur:        "1b3b1d210dd60b7f92ca7dd1c270283a75a3ff9b8281a14aff435bf31a9f1b42"
    sha256 cellar: :any_skip_relocation, catalina:       "b025595bf15e3b6f5eb6d6b58ae211d32757346567c149f4bac7298e7b7474c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0877fab1b4a37ec9bdc3309e664d4ffa9546b9b36abead3f5d0a6356febe5b03"
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
