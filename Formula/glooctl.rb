class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.13.0",
      revision: "28fddf2da21749a8f3808016e670a4206038522b"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a61f6d8b4156840cbfba9cd260a9aed0d86218b3ad0155705f3a9dbe3528feb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a5b88d97ededad22dbf744eef83085f1a804cd8e872febfc07b47b56ab78964"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d2b96cdf8904efc01f8bee8a911faa1297afbe008595581c845cd22d83079fdf"
    sha256 cellar: :any_skip_relocation, ventura:        "64ebdf9140a55bd8009983421e8955914e38a130162946d4e07ea33feda1c640"
    sha256 cellar: :any_skip_relocation, monterey:       "e6fb6d7ad1dea653f2ae674ba71e91292e8402927512718eb9f6d31a7d58a5ce"
    sha256 cellar: :any_skip_relocation, big_sur:        "8a5fc114817a150f8bcf8c16aa35c30bec70eebe5a386515ac72729765da5f27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c3256e9aff6d5c7def829eb3575994a60c7dee0afc7a406aa68a0ce1dba1bf2"
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
