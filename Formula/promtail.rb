class Promtail < Formula
  desc "Log agent for Loki"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.7.1.tar.gz"
  sha256 "363f7ba0782e3eb1cfa89b1240311b182ce3e1c0c53497f18e876e71749f0e89"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f602ab335447cae2f70f9efc9f936aafea7ad7e574a2c3d07779604dddea7f5c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68afb558290725cbb4fea58878d1cf01813b5542f579faddd5400963c649b3e0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1bb7f0c24ea6c3cc9be6eab2e703fd6f3396c78683dddcefeab209c1163c1986"
    sha256 cellar: :any_skip_relocation, ventura:        "e7d44013a64f9195a366295bbc0fc8e41badc6c95c1244e982f41911ad237a41"
    sha256 cellar: :any_skip_relocation, monterey:       "25273c750f0f8a73cf540520f3bf77fb8b335bce7fe3e839270e71bdccc31621"
    sha256 cellar: :any_skip_relocation, big_sur:        "910184741b28d913024a2af799aeecf0056858b8c4271eccde5cdf1fc462af3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73561dabf02b2db010a1c5e3fe2948e8c7a5c530c7e7aa76765f83b78e7318e0"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "systemd"
  end

  def install
    cd "clients/cmd/promtail" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
      etc.install "promtail-local-config.yaml"
    end
  end

  service do
    run [opt_bin/"promtail", "-config.file=#{etc}/promtail-local-config.yaml"]
    keep_alive true
    working_dir var
    log_path var/"log/promtail.log"
    error_log_path var/"log/promtail.log"
  end

  test do
    port = free_port

    cp etc/"promtail-local-config.yaml", testpath
    inreplace "promtail-local-config.yaml" do |s|
      s.gsub! "9080", port.to_s
      s.gsub!(/__path__: .+$/, "__path__: #{testpath}")
    end

    fork { exec bin/"promtail", "-config.file=promtail-local-config.yaml" }
    sleep 3

    output = shell_output("curl -s localhost:#{port}/metrics")
    assert_match "log_messages_total", output
  end
end
