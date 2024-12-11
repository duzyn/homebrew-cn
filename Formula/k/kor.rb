class Kor < Formula
  desc "CLI tool to discover unused Kubernetes resources"
  homepage "https://github.com/yonahd/kor"
  url "https://mirror.ghproxy.com/https://github.com/yonahd/kor/archive/refs/tags/v0.5.7.tar.gz"
  sha256 "db3e4e32738e1dc9a47901937754c589b399e9cae2a4c65eb1bc46b89a14453e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "930b64b5619e91003946fa75977aaee86f0739f587108dc12a29a46f0d484ea9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "930b64b5619e91003946fa75977aaee86f0739f587108dc12a29a46f0d484ea9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "930b64b5619e91003946fa75977aaee86f0739f587108dc12a29a46f0d484ea9"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab725bfa29c94d9d9a594f1fdde6f44d5235d293ac350b22f31aae03d8eb3c76"
    sha256 cellar: :any_skip_relocation, ventura:       "ab725bfa29c94d9d9a594f1fdde6f44d5235d293ac350b22f31aae03d8eb3c76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f297e41d3bcc094cf98817c8a9041d5b2c59af19e41fe817faf88f5e3a33a1cd"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/yonahd/kor/pkg/utils.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kor", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kor version")

    (testpath/"mock-kubeconfig").write <<~EOS
      apiVersion: v1
      clusters:
        - cluster:
            server: https://mock-server:6443
          name: mock-server:6443
      contexts:
        - context:
            cluster: mock-server:6443
            namespace: default
            user: mockUser/mock-server:6443
          name: default/mock-server:6443/mockUser
      current-context: default/mock-server:6443/mockUser
      kind: Config
      preferences: {}
      users:
        - name: kube:admin/mock-server:6443
          user:
            token: sha256~QTYGVumELfyzLS9H9gOiDhVA2B1VnlsNaRsiztOnae0
    EOS
    out = shell_output("#{bin}/kor all -k #{testpath}/mock-kubeconfig 2>&1", 1)
    assert_match "Failed to retrieve namespaces: Get \"https://mock-server:6443/api/v1/namespaces\"", out
  end
end
