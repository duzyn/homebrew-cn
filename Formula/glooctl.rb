class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.12.37",
      revision: "e912fc966e14b0db70dff17469c22c2358761ba4"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2dcac6cfcb84d0bdb254688e395246a1b11de8e012a0e9d28db2d32ec2a30ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09d68b77f19470b23310dde140e5e6f079a31e888b8b6dbe37d7db08ce42f5d3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "44a6a912eefdc1d7c96f6ad17c9ef9b44c04be3e7c5c192cfe0e7cef84189eee"
    sha256 cellar: :any_skip_relocation, ventura:        "00c17bb636fa633b2b2db8a3cc704bf2f371237d4c35a38b4c8d9a2f888d262e"
    sha256 cellar: :any_skip_relocation, monterey:       "f9e20c663532fea906db5a2726d180de0b077b8f24be0eac51fbc0ce878754e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "9d26dea8fd5e13bb976a8742c3ac3449e81c3590c31af11cde9fb94991394e3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbabd73071972297aea07d7248e9903092ff87c9f83a3701222583d78590a923"
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
