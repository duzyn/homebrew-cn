class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.38.0.tar.gz"
  sha256 "2dd735723742e3b26ac423f8df971edac919c38477550e499d1a7b5a786cf2e1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "86a41cc286aad51d7d271a58696a1e2a760e59c29848bb4cf2a3a4885a3d1a6f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99a6fab538129d357278cc81be73e274eeb680997e8a8197681a84d9a2af40ac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "308014b47e171df24f2ecf9434a2c6554560be767cfacae411694195383453ba"
    sha256 cellar: :any_skip_relocation, ventura:        "3488539acde3cb20c303efb2901cc18691322d0a7dcf81fd7a12868381a734c6"
    sha256 cellar: :any_skip_relocation, monterey:       "429f3b57665e00db7b296e0a162fe788f628dceb765e746ed0433d36467685d9"
    sha256 cellar: :any_skip_relocation, big_sur:        "729711f26257206e1d16dd96add3d7147168e14679b18e305276e388b832f05c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "287b1b6f2baae00d91417f44c2f63c1175d388b79135632f5220909d71232714"
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
