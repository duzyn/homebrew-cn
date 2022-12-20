class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.39.0.tar.gz"
  sha256 "6a08bed92ecf18aabc7781008809ae9986776fccf40f8ca31cb880ee9bc7f243"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d2532cf000685fdb7487c775a5a55b61b24d431cc4e3989c0cc0ca0d130b0137"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7842b604195d94b9df9f55ecc189afae916dbb3b2401f7ec946555c8460c8454"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "88b6dff25e95068a1d1ddfc187e9ad14b2f82aa0e5c8acd5b1fe6c983b8e7aca"
    sha256 cellar: :any_skip_relocation, ventura:        "67be0097120391bcb35d2c0199ce3075c332c2117fa5cda1b706cd5d8d471229"
    sha256 cellar: :any_skip_relocation, monterey:       "a12e437a7cc40b36670becb885bf1603a2e870e43b4a3f401c2b952d080d6bbf"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd1828bdcc3867b75cfe8a0f1095b24bfb250196a4d43ff6056c5c88087c654c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00060bba72023ed4d46c328d92149e4d05b0b5937a77232b49726abc293d621e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/pint"

    pkgshare.install "docs/examples"
  end

  test do
    (testpath/"test.yaml").write <<~EOS
      groups:
      - name: example
        rules:
        - alert: HighRequestLatency
          expr: job:request_latency_seconds:mean5m{job="myjob"} > 0.5
          for: 10m
          labels:
            severity: page
          annotations:
            summary: High request latency
    EOS

    cp pkgshare/"examples/simple.hcl", testpath/".pint.hcl"

    output = shell_output("#{bin}/pint -n lint #{testpath}/test.yaml 2>&1")
    assert_match "level=info msg=\"Loading configuration file\" path=.pint.hcl", output
    assert_match "level=info msg=\"Problems found\" Warning=3", output

    assert_match version.to_s, shell_output("#{bin}/pint version")
  end
end
