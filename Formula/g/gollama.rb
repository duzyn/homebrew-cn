class Gollama < Formula
  desc "Go manage your Ollama models"
  homepage "https://smcleod.net"
  url "https://mirror.ghproxy.com/https://github.com/sammcj/gollama/archive/refs/tags/v1.27.21.tar.gz"
  sha256 "657383d8da901b0ebb7d473c0e4a71db7a06cf0517555674ec6e5f48bf03f067"
  license "MIT"
  head "https://github.com/sammcj/gollama.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe65ae064414b95f2c5d735aaf4a23dd199c1e0a2e092fc521021a582f9bf136"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bad8538a7ae49466006e8f74e07ded411553ea284a09175f39f7979fc0fe0162"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1c0346a91177342025709d3ffd0f2f7e979abca9d15d30bd1811b13f92c016b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d2652b13021b6e4b6a1e0054043aff622946e71a5e2ceb08cb4580702838b4a"
    sha256 cellar: :any_skip_relocation, ventura:       "dadf1574f1e1f43bb542fd23006fb2a7431efe89acc36beda15cb128f3a5a575"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "410c6cf19c1fb8a25fe682550352c32ba3493bc9e47071792f589fc7398a5d35"
  end

  depends_on "go" => :build
  depends_on "ollama" => :test

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output(bin/"gollama -v")

    port = free_port
    ENV["OLLAMA_HOST"] = "localhost:#{port}"

    pid = fork { exec "#{Formula["ollama"].opt_bin}/ollama", "serve" }
    sleep 3
    begin
      assert_match "No matching models found.",
        shell_output(bin/"gollama -h http://localhost:#{port} -s chatgpt")
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end
