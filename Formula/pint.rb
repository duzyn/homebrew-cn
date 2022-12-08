class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.37.0.tar.gz"
  sha256 "9d0bdc07e254b729d1ebad29207f4469d7bf92e93c68a3f919b97eee832caf82"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9b2771df41b015213396a697a57205ed1110a23373f57233550562cf34c3003"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0011adc6996dd9520257cbabe11c33538186da9b01a7cf4562e0fdc13cef34fd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "22829e5d6a495d6d29f709b0ec3016e507d62aa6f01e3acd4880b293a8322375"
    sha256 cellar: :any_skip_relocation, ventura:        "20647cbd0b01ca784256af4e81f0a8829906ce78c94c631293acbfe037023047"
    sha256 cellar: :any_skip_relocation, monterey:       "e1fe181f06922fb363e169cab587d7564a0692dc18a6f287c0f4c4d2e313d6e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "65b67ef9f98e6527723c0a2856ee2caee8eba99b761556c3bc368fa63be21621"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee4e302f71f50359373bf3a2b6a14de88f4c0c17c7332d36d4f77b173675d5ae"
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
