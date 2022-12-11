class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v2.40.6.tar.gz"
  sha256 "d1ff0be51cb959c67e88b7e4e100488cbd449e40d0a8fce22c893920ac7a940f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9840a2b17a5074c398e871bb16b598b0fd9ff22626b4ed0389e824077b58db00"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2dd8a84f7e6fe78a583ec86a7e71bc81efebc00ee204d19320f5944908e15803"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e083db098baedd9bd314aa59b37c9717abd28aebce5bbee36a42dfde549b8a73"
    sha256 cellar: :any_skip_relocation, ventura:        "9bb509d6c03575c1fdb92d2dc576f00b2e1731d182601f113895bb0307e0c1ec"
    sha256 cellar: :any_skip_relocation, monterey:       "24fd98c67079d0dfed29f5495c902e6dcf619a79e5c44ef4525c4444b3fd559e"
    sha256 cellar: :any_skip_relocation, big_sur:        "5694be1f1b982a0fba976e1cf9116a1d444b149b42d10a48574a1271ee7e6156"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39e7f97ed1e17f609efa2b41cd2bc2646f720a3f3b80105f9947c238b9557076"
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
