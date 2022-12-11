class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.7.1.tar.gz"
  sha256 "363f7ba0782e3eb1cfa89b1240311b182ce3e1c0c53497f18e876e71749f0e89"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "805cf68ccf04a669620306c02f0a0bdd76e26f2689c1fe39bf6c15d458ff4888"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e29465950ef27c6896ce9a8a3736cd9bdd7cfd795994d3d3c596f76221204b29"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f289685799dd44ed1a7cd88f15409be76a0bd403975230f184771942d3b1edb"
    sha256 cellar: :any_skip_relocation, ventura:        "eea3c314f07d31ce220e77634ba1daf7f0d49e542ab9a29d7215240876b54308"
    sha256 cellar: :any_skip_relocation, monterey:       "455470aa389379f8b90d699bb670cbf92f842ddc55b0e95a62b5abc90e7923ad"
    sha256 cellar: :any_skip_relocation, big_sur:        "b29ae242ff5b41099e22fb000b96003812d6d434abe62531f184f5f51dfb8495"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d8559445f84b659e2f13ab780d9131a7f1129eb7222247023604f6bce09c90a"
  end

  depends_on "go" => :build

  def install
    cd "cmd/loki" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
      inreplace "loki-local-config.yaml", "/tmp", var
      etc.install "loki-local-config.yaml"
    end
  end

  service do
    run [opt_bin/"loki", "-config.file=#{etc}/loki-local-config.yaml"]
    keep_alive true
    working_dir var
    log_path var/"log/loki.log"
    error_log_path var/"log/loki.log"
  end

  test do
    port = free_port

    cp etc/"loki-local-config.yaml", testpath
    inreplace "loki-local-config.yaml" do |s|
      s.gsub! "3100", port.to_s
      s.gsub! var, testpath
    end

    fork { exec bin/"loki", "-config.file=loki-local-config.yaml" }
    sleep 3

    output = shell_output("curl -s localhost:#{port}/metrics")
    assert_match "log_messages_total", output
  end
end
