class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.13.2",
      revision: "da1111d61cc34b355f15a231743b7efe653cf46b"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c23d01a39bcafda8ed678c318c03d72176d68b5306a13f37ae91bb6c332f8f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef233bb8fdb94452bcb9295aa3dda2542a71dce960e256e0b45dd1b9ce95fb11"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f20b9ea396212f78bfea3229dc5461eedff8f66bd0901242b9d45e0664599456"
    sha256 cellar: :any_skip_relocation, ventura:        "6da9cc699cdc3b692e61bc2cbb64c9c0748caa16050f3514a59ca083bb227ac1"
    sha256 cellar: :any_skip_relocation, monterey:       "548f4837a0a6862437cdb72fda5aa6634ab7cd03edd04393bbb8fe94ce9236cd"
    sha256 cellar: :any_skip_relocation, big_sur:        "8343664a6dea8bea22ed46e1b84c5c5b8e3841d0ffb7e2f227099d60d361175c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5105805c2ee3b0aa0f852f5586355ca7a0276f7dbc6e59f9be8a09a8c1193033"
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
