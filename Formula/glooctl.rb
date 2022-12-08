class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.12.36",
      revision: "8533ccc90a1740fa1ef4f2b33fb83fd81c41bca8"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e918290f61f599e61f7d9893f153dca19f7dad19d1e4834c55a98c6c9dd4736"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b542c4c19dc23419bb6b8b9107339c108c0ced27b8202270ae7b03449d113aaa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1de64d0adf4eb61525a1cad7a3861b9135e5a62ee2b3b6d973f8b71087d5b9fd"
    sha256 cellar: :any_skip_relocation, ventura:        "4c0e1b81bfe3eb259f07534b71456822925f71f24d4f745ee7a3bda3b1950671"
    sha256 cellar: :any_skip_relocation, monterey:       "f151f2ad839b8808e1eddce69aa64c949faff4f9fd455a389500a1ea18d425f9"
    sha256 cellar: :any_skip_relocation, big_sur:        "5cc6fe574a7a9e636cde2ade9bf3ae75394f1ad79f3f0b39d8169efc4876ba25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8605afdd14eea0520a11774e9317b2768f8949880b2bd1cbb8e6998f421d6de4"
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
