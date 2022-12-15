class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v2.40.7.tar.gz"
  sha256 "83b4e891204500fc798b5a9e86d0189cbef7f8274c3303c215da5e2c75df6cde"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "215ce4f2d56a79b8c0c2293a00aef793a7fe20bb3a87e1902cf0d4b0d3c580d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2668b5fc840ad1a573530728420f9e657b9508b033ae3fc6dcb080d06b56fb2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2855fcbe1e10952da88334cc737fe4ad696224162f8992cfd726b86ad26a63cf"
    sha256 cellar: :any_skip_relocation, ventura:        "76e7f458f97ff914bc533c72ce5cb635f0317ffa2f14bc6675924dfd82dc3458"
    sha256 cellar: :any_skip_relocation, monterey:       "4be92bce382dec5b5a2b5153f98f5cbfefdfa2ce8aba2c6747e07540422cc940"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d24fa4f4d7d6866f442e57da1b78662ee58cf30f0200d7060c154ad956f0131"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6329dcd9c3ef94b4df7575bf2848fb99b88032e34fa35906e6ec57d0f27e1ce9"
  end

  depends_on "gnu-tar" => :build
  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    ENV.deparallelize
    ENV.prepend_path "PATH", Formula["gnu-tar"].opt_libexec/"gnubin"
    ENV.prepend_path "PATH", Formula["node"].opt_libexec/"bin"
    mkdir_p buildpath/"src/github.com/prometheus"
    ln_sf buildpath, buildpath/"src/github.com/prometheus/prometheus"

    system "make", "assets"
    system "make", "build"
    bin.install %w[promtool prometheus]
    libexec.install %w[consoles console_libraries]

    (bin/"prometheus_brew_services").write <<~EOS
      #!/bin/bash
      exec #{bin}/prometheus $(<#{etc}/prometheus.args)
    EOS

    (buildpath/"prometheus.args").write <<~EOS
      --config.file #{etc}/prometheus.yml
      --web.listen-address=127.0.0.1:9090
      --storage.tsdb.path #{var}/prometheus
    EOS

    (buildpath/"prometheus.yml").write <<~EOS
      global:
        scrape_interval: 15s

      scrape_configs:
        - job_name: "prometheus"
          static_configs:
          - targets: ["localhost:9090"]
    EOS
    etc.install "prometheus.args", "prometheus.yml"
  end

  def caveats
    <<~EOS
      When run from `brew services`, `prometheus` is run from
      `prometheus_brew_services` and uses the flags in:
         #{etc}/prometheus.args
    EOS
  end

  service do
    run [opt_bin/"prometheus_brew_services"]
    keep_alive false
    log_path var/"log/prometheus.log"
    error_log_path var/"log/prometheus.err.log"
  end

  test do
    (testpath/"rules.example").write <<~EOS
      groups:
      - name: http
        rules:
        - record: job:http_inprogress_requests:sum
          expr: sum(http_inprogress_requests) by (job)
    EOS
    system "#{bin}/promtool", "check", "rules", testpath/"rules.example"
  end
end
