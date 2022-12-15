class Mimirtool < Formula
  desc "CLI for interacting with Grafana Mimir"
  homepage "https://grafana.com/docs/mimir/latest/operators-guide/tools/mimirtool/"
  url "https://github.com/grafana/mimir.git",
        tag:      "mimir-2.4.0",
        revision: "32137ee2c4c41fa649abfb9582e1f33a9e13363b"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/mimir.git", branch: "main"

  livecheck do
    url :stable
    regex(/^mimir-(\d+\.\d+\.\d+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "63863ff7843331ff1e122519247bd29c374813276d69119f5862205a5b72e70f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3d90ce45e41033cc2cc3a97a8307e530a3ae376e27e95b7372dbba12d99ec2c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7c9ddf7abb7f639d4428ee97028c1fff4723a310f1c1f414aa334c0f80d0630f"
    sha256 cellar: :any_skip_relocation, ventura:        "53c25c35eef0fe6424166cc175e57fcd74835c1021510e449a86040983aaf90d"
    sha256 cellar: :any_skip_relocation, monterey:       "b65031d565051a00cf59ab0101b590fb65ca6ce375833f49bcbb1b2f09da1fb0"
    sha256 cellar: :any_skip_relocation, big_sur:        "05086c58f081ad16066d5396a65f0d5d5fc457b13af217d1575df7801b32601e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "439fb6a4c0513af52c647696b51dcb299ee234c13a2d349d9efd243935b02be7"
  end

  depends_on "go" => :build

  def install
    system "make", "BUILD_IN_CONTAINER=false", "cmd/mimirtool/mimirtool"
    bin.install "cmd/mimirtool/mimirtool"
  end

  test do
    # Check that the version number was correctly embedded in the binary
    assert_match version.to_s, shell_output("#{bin}/mimirtool version")

    # Check that the binary runs as expected by testing the 'rules check' command
    test_rule = <<~EOF
      namespace: my_namespace
      groups:
        - name: example
          interval: 5m
          rules:
            - record: job_http_inprogress_requests_sum
              expr: sum by (job) (http_inprogress_requests)
    EOF

    (testpath/"rule.yaml").write(test_rule)

    output = shell_output("#{bin}/mimirtool rules check #{testpath / "rule.yaml"} 2>&1", 1)
    expected = "recording rule name does not match level:metric:operation format, must contain at least one colon"
    assert_match expected, output
  end
end
