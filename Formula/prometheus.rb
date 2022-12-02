class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v2.40.5.tar.gz"
  sha256 "b28692e625b6d9b00676bab7251ae23f4bebdf060df55c6e2ea3eea89a5f01a5"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c549592856b1f1776ae5276d0de7becd65b1f411ae17af58a4edc2b9284276d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eae0628c687a8d008669222288215f12a06cea0b55902c95c96e417b068b765f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3e0a67ccf6118d5c9425ece8df8e7adae9fa0009b098b43e3cc5717471c29d0e"
    sha256 cellar: :any_skip_relocation, ventura:        "d48c72d117f24bc72d35b8f9951d75d448324703ec09de6f67aeb068623596ea"
    sha256 cellar: :any_skip_relocation, monterey:       "7ef0661518cb63362d11ea9243ce9fb75c323641017871b59049e83e624aef2a"
    sha256 cellar: :any_skip_relocation, big_sur:        "35bc7860a171e63a8a4b1d64ecda47aae9207c3fe7ebf950044e06683bc4435d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79ce94bb200ea65a20af3237b275211f9a24bd319c152a021786c91905d1bd48"
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
