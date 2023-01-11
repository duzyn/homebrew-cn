class Cmctl < Formula
  desc "Command-line tool to manage cert-manager"
  homepage "https://cert-manager.io"
  url "https://github.com/cert-manager/cert-manager.git",
      tag:      "v1.10.2",
      revision: "707dcff96a26445c1f0897e9e623625695200eab"
  license "Apache-2.0"
  head "https://github.com/cert-manager/cert-manager.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2af9aa9088c7940b8d3a839752eb8225038733af57ff73fe9dd9472bfc20e8c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "673b3d546dd0baa10e6a01945cd2454a4b9f4ec275a23a53b5fae42c73c5670f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d3fc723c989d060146dc23b2f26015a1a4a481f2b44365703379db6e11ee00b"
    sha256 cellar: :any_skip_relocation, ventura:        "ba4aa065d4e0308d002f0b4c663505bda4512de09331c5304ac34908a1a1a550"
    sha256 cellar: :any_skip_relocation, monterey:       "c76289458f42d4b63c7d784fb8ad0037c40c07e8bdef216400b08749ad8c87f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "c1c1f7567aed66c0cb63b530a41221f078a5cc25f4da7846a696f7a614a308c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7ff6f455fc6c5d7accde2bdc687f88f8b499c5daa31e49b13e7c8a4f55ae355"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/cert-manager/cert-manager/cmd/ctl/pkg/build.name=cmctl
      -X github.com/cert-manager/cert-manager/cmd/ctl/pkg/build/commands.registerCompletion=true
      -X github.com/cert-manager/cert-manager/pkg/util.AppVersion=v#{version}
      -X github.com/cert-manager/cert-manager/pkg/util.AppGitCommit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/ctl"
    generate_completions_from_executable(bin/"cmctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cmctl version --client")
    # The binary name ("cmctl") is templated into the help text at build time, so we verify that it is
    assert_match "cmctl", shell_output("#{bin}/cmctl help")
    # We can't make a Kuberntes cluster in test, so we check that when we use a remote command
    # we find the error about connecting
    assert_match "connect: connection refused", shell_output("#{bin}/cmctl check api 2>&1", 1)
    # The convert command *can* be tested locally.
    (testpath/"cert.yaml").write <<~EOF
      apiVersion: cert-manager.io/v1beta1
      kind: Certificate
      metadata:
        name: test-certificate
      spec:
        secretName: test
        issuerRef:
          name: test-issuer
          kind: Issuer
        commonName: example.com
    EOF

    expected_output = <<~EOF
      apiVersion: cert-manager.io/v1
      kind: Certificate
      metadata:
        creationTimestamp: null
        name: test-certificate
      spec:
        commonName: example.com
        issuerRef:
          kind: Issuer
          name: test-issuer
        secretName: test
      status: {}
    EOF

    assert_equal expected_output, shell_output("#{bin}/cmctl convert -f cert.yaml")
  end
end
