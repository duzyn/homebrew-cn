class Mimirtool < Formula
  desc "CLI for interacting with Grafana Mimir"
  homepage "https://grafana.com/docs/mimir/latest/operators-guide/tools/mimirtool/"
  url "https://github.com/grafana/mimir.git",
        tag:      "mimir-2.5.0",
        revision: "25533fdfcf5d8e26ee8f49bcaf13e30bd678d4b3"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/mimir.git", branch: "main"

  livecheck do
    url :stable
    regex(/^mimir-(\d+\.\d+\.\d+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5b52e8915e04c0d174a2eab443ee2dcada73fe01a8c3454e3e78e5f6e5e1c624"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c12f4f48e17cff5977558083e02145caa4ae27e623c5aa1f1a8585bb49059c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "803ca2e2cde3f36fb62ea4a0d7d8048d4e946d15d1b9e7b04c9db620beff8ac0"
    sha256 cellar: :any_skip_relocation, ventura:        "23e61f68c02eaf2753b1e020403e26a129f39bacea96d33425a41725809fd1ba"
    sha256 cellar: :any_skip_relocation, monterey:       "ca44ba45ff5409b332378329a594a902160f6b17fc79115c1c7fedb54424b0da"
    sha256 cellar: :any_skip_relocation, big_sur:        "c568c2e4923350f6bc6cd54f751d101b0d8bba3b756eb14789d5e9c3ee5d2df0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d99cf86eb8ab8fbffbff8bdb5f4b6fd00858f82bcd3bd99ff9efabe452422328"
  end

  depends_on "go" => :build

  def install
    system "make", "BUILD_IN_CONTAINER=false", "GENERATE_FILES=false", "cmd/mimirtool/mimirtool"
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
