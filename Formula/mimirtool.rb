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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8798e09032fbf45a36306fc67f743c8503d25000a088394d1c7758fafd210d14"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f47c139d6d29ea5dee2a234f924d9a42cc182727bc4bfd411e5a09723648de95"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ecdea14e495f78412e95c11c1c0d3964f6874bb1971311cf442e6378f93b25b"
    sha256 cellar: :any_skip_relocation, ventura:        "6d1c79274c95d2b7172e7eaf27a4c228ffdc8e2b48c01cf3e50c04c7824fc970"
    sha256 cellar: :any_skip_relocation, monterey:       "7a0d2b44eb7185ff06bd2d4d1293fc7e5c3afe2970ac3c0b3a88f855206571ad"
    sha256 cellar: :any_skip_relocation, big_sur:        "485799543f5fc60af10fe3ed84db7c9836c281830024053df0868cc09034ae55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7d30d8e358fe89099739d49ab75dcee73ae49e69f478ebb5f3fef9a43d6c221"
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
