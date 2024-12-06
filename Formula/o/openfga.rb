class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://mirror.ghproxy.com/https://github.com/openfga/openfga/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "ef79047a7daa1e41443717654321b567aed64cec65727145b64a52dafff0d071"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5762166d430fb0a6f55d89af032e18c99f89caa4be213aa1f4e200f90a51f472"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5762166d430fb0a6f55d89af032e18c99f89caa4be213aa1f4e200f90a51f472"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5762166d430fb0a6f55d89af032e18c99f89caa4be213aa1f4e200f90a51f472"
    sha256 cellar: :any_skip_relocation, sonoma:        "dbf16809ea50734acd1310c570988d16959536a7cf80b3b49f5baecf7947d706"
    sha256 cellar: :any_skip_relocation, ventura:       "dbf16809ea50734acd1310c570988d16959536a7cf80b3b49f5baecf7947d706"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b35e1f7189ef7cc63cb877a5d25781fca28c3416b22750ece7acf8ee5156f9a"
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
