class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://mirror.ghproxy.com/https://github.com/openfga/openfga/archive/refs/tags/v1.5.7.tar.gz"
  sha256 "cbe756e2b1c65368751282b515df47ce828ca728b61733dc3fadd974fd8d596e"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e23d5cac060543e40507ffde78603b09344c2dee505c6a5bb4202394928dadb6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ea6b153875926325599c986a470066a2c32c17d3e63effc0472c92a9c6868ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06ff3ba48d80c6f76743894e036e86791a56db427d44ce09b72a82fcf603dc66"
    sha256 cellar: :any_skip_relocation, sonoma:         "385742018b01ee31ab60b6acd083571826447abb12e013dbb9d63427762f0892"
    sha256 cellar: :any_skip_relocation, ventura:        "dcc7f6c1eb4a8b1c3896a87cceb0e83dcdc171e6c19b2340d0caca9a0a1260fb"
    sha256 cellar: :any_skip_relocation, monterey:       "8129b7f9ce46566d006b7fbecd8c80acb4899a2914205ad06a43816cdfe400b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e66fee57c1f2063b2df6364fc9a5ae5816a4ec361606098778e8258b721eca87"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/openfga/openfga/internal/build.Version=#{version}
      -X github.com/openfga/openfga/internal/build.Commit=brew
      -X github.com/openfga/openfga/internal/build.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/openfga"

    generate_completions_from_executable(bin/"openfga", "completion")
  end

  test do
    port = free_port
    pid = fork do
      exec bin/"openfga", "run", "--playground-port", port.to_s
    end
    sleep 3
    output = shell_output("curl -s http://localhost:#{port}/playground")
    assert_match "title=\"Embedded Playground\"", output

    assert_match version.to_s, shell_output(bin/"openfga version 2>&1")
  ensure
    Process.kill("SIGTERM", pid)
    Process.wait(pid)
  end
end
