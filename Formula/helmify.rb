class Helmify < Formula
  desc "Create Helm chart from Kubernetes yaml"
  homepage "https://github.com/arttor/helmify"
  url "https://github.com/arttor/helmify.git",
      tag:      "v0.3.21",
      revision: "6cb59e43918162f6d02d4e67016b79c914fcb2dc"
  license "MIT"
  head "https://github.com/arttor/helmify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b0be339cc53f7ac37137cb7d07ab0b60922d06cfd5436a2c54e3c9e0677297e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "209081986e501bc81db0012ae4ead3cbed3906fe1ac3ebd554df7bb9ed1a4b61"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "35a5c6dd990c99f999572746c80c706b58c8efe8a00484bf200576ac08b14fd4"
    sha256 cellar: :any_skip_relocation, ventura:        "fce633c5953ee44322864bb1b01f8865b882144a686c05ca81f360b28c1a0cd8"
    sha256 cellar: :any_skip_relocation, monterey:       "90bc0d8698832e43b68d7da4afb4afd5615b3524428187ed2bca2e0efc4fec39"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a21be8644f312a2536eafd15188641948ad8f75513c7f8aa0a2831c55becc55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b63756defddc6b3d9589cd54fe77237ef5de227cb3090b07d018f2868d4e75d7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
      -X main.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/helmify"
  end

  test do
    test_service = testpath/"service.yml"
    test_service.write <<~EOS
      apiVersion: v1
      kind: Service
      metadata:
        name: brew-test
      spec:
        type: LoadBalancer
    EOS

    expected_values_yaml = <<~EOS
      brewTest:
        ports: []
        type: LoadBalancer
      kubernetesClusterDomain: cluster.local
    EOS

    system "cat #{test_service} | #{bin}/helmify brewtest"
    assert_predicate testpath/"brewtest/Chart.yaml", :exist?
    assert_equal expected_values_yaml, (testpath/"brewtest/values.yaml").read

    assert_match version.to_s, shell_output("#{bin}/helmify --version")
  end
end
