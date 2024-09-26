class KamalProxy < Formula
  desc "Lightweight proxy server for Kamal"
  homepage "https://kamal-deploy.org/"
  url "https://mirror.ghproxy.com/https://github.com/basecamp/kamal-proxy/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "731c6219e6e88f7f2cc039216bd54111320b2a79e89883ebab3fe3d6ec089474"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f59ccfd0e8fdd4a502f22e4db0b3b25550f1188cabea1b0225ed53eccc46a09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f59ccfd0e8fdd4a502f22e4db0b3b25550f1188cabea1b0225ed53eccc46a09"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5f59ccfd0e8fdd4a502f22e4db0b3b25550f1188cabea1b0225ed53eccc46a09"
    sha256 cellar: :any_skip_relocation, sonoma:        "6628b1db22b4a8004eee23e64bbcc2b94ca2f6e5c8b7cde4e8baf5a8e044b723"
    sha256 cellar: :any_skip_relocation, ventura:       "6628b1db22b4a8004eee23e64bbcc2b94ca2f6e5c8b7cde4e8baf5a8e044b723"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0eb772cb2fc5f7ba4a3c014ed6d39a6c73a2d7dddd3367e9b58d6db4697ec98"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/kamal-proxy"
  end

  test do
    assert_match "HTTP proxy for zero downtime deployments", shell_output(bin/"kamal-proxy")

    read, write = IO.pipe
    port = free_port
    pid = fork do
      exec "#{bin}/kamal-proxy run --http-port=#{port}", out: write
    end

    system "curl -A 'HOMEBREW' http://localhost:#{port} > /dev/null 2>&1"
    sleep 2

    output = read.gets
    assert_match "No previous state to restore", output
    output = read.gets
    assert_match "Server started", output
    output = read.gets
    assert_match "user_agent\":\"HOMEBREW", output
  ensure
    Process.kill("HUP", pid)
  end
end
