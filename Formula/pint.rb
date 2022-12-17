class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.38.1.tar.gz"
  sha256 "79f5495eec3c3757e5229f3b7d1f6683a2c3a70daa9f205b48e4f52d601066e0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7eca459d0e80d5ce5881fe31ab40b27d86cd6d09a73b0c8195f5e5913905516"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2117d48330971563bde766b464cb91d0ec3b7b1a2c3d95242a673d6a761713f6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "18c506b7d24ab6409e2be3b1cecf380672557a08dff8c7b330c9932dc4c9940a"
    sha256 cellar: :any_skip_relocation, ventura:        "97187f257ee15a6c81c835dbe737fc3c2452c038c47c9d4f6bf448ee6e29f7ee"
    sha256 cellar: :any_skip_relocation, monterey:       "b6f67efc92b47460b9aa982cce62564cb9990e8114c0b8323866657f371201c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "0ce415aa67bcc52c5544063f6b1f6f5e25b4364223177cc3de9967d3725c6232"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a92e0413adfc947eada25a571f639326262b606969c478de24e914e958cf7c21"
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
