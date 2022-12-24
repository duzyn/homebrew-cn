class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.13.1",
      revision: "a94f597ed66e1d621ca621d2bf37f4cf63d6559b"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a764e86c517fbf58e7451e44e2982e5b0eea8842f097f63329db01f3ea45f041"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5aef98913a1cb72c0807da06ea65a6d38f1102e1338af76926bd445d31510c7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "746cf0d9e264a2a4d46ceade8e90cd13a852545c2123b19d23c182edeb77b961"
    sha256 cellar: :any_skip_relocation, ventura:        "ea38a174f9a88fc88a2e6580eaa6f4657e88cbe10c308805c3be83b18bc48346"
    sha256 cellar: :any_skip_relocation, monterey:       "f1386b98087c4c3c7c8f2325077dbcb3fb36bb858d22173093cac8d5031cc985"
    sha256 cellar: :any_skip_relocation, big_sur:        "ec2ec1b89ae698c265a7dd543feddc60d88b0fdcc67e01cecb3cfa07c6d54b0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a28896c99bc739216647f77fb170d91eebe679e99e64a6c1491f1cb9c00b4968"
  end

  depends_on "go" => :build

  def install
    system "make", "glooctl", "VERSION=#{version}"
    bin.install "_output/glooctl"

    generate_completions_from_executable(bin/"glooctl", "completion", shells: [:bash, :zsh])
  end

  test do
    run_output = shell_output("#{bin}/glooctl 2>&1")
    assert_match "glooctl is the unified CLI for Gloo.", run_output

    version_output = shell_output("#{bin}/glooctl version 2>&1")
    assert_match "Client: {\"version\":\"#{version}\"}", version_output
    assert_match "Server: version undefined", version_output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    status_output = shell_output("#{bin}/glooctl get proxy 2>&1", 1)
    assert_match "failed to create kube client", status_output
  end
end
