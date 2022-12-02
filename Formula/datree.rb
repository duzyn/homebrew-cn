class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://datree.io/"
  url "https://github.com/datreeio/datree/archive/1.8.8.tar.gz"
  sha256 "53e2575845e59b05bb4f1210925065512d374a44eb9e80633b3e3a5f8099a2f8"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "05fec2ecd19d58c09f86d0dd809ee8c73e7ff61a0f9845b6a95f808e125cbd76"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "546eddc13fae7f7dac1a9744fbe74bc5a3949525f391ceee9b3f6a8638724386"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0ea41d30268f41ae99d55e2b2ae3db341e08c0aeea2067228fd66e11db2d61d1"
    sha256 cellar: :any_skip_relocation, ventura:        "943b3bd4427dfbed9df2448fdf2eabfe95dc8c391a58dbd638d1b9441dd1995f"
    sha256 cellar: :any_skip_relocation, monterey:       "fd9e970f28d644b00498fa2c1c19dadc4a8095daebba10820c6865f21c331b23"
    sha256 cellar: :any_skip_relocation, big_sur:        "3610c305a9b42766b3f313df97dcff4d317779e8cfe4bac22cdf3541c67f333f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd06ec59c6e2a750e50518217dbfa14de37e4adbb025155c2b6f1a430bd9b4c4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/datreeio/datree/cmd.CliVersion=#{version}"), "-tags", "main"

    generate_completions_from_executable(bin/"datree", "completion")
  end

  test do
    (testpath/"invalidK8sSchema.yaml").write <<~EOS
      apiversion: v1
      kind: Service
      metadata:
        name: my-service
      spec:
        selector:
          app: MyApp
        ports:
          - protocol: TCP
            port: 80
            targetPort: 9376
    EOS

    assert_match "k8s schema validation error: For field (root): Additional property apiversion is not allowed",
      shell_output("#{bin}/datree test #{testpath}/invalidK8sSchema.yaml --no-record 2>&1", 2)

    assert_match "#{version}\n", shell_output("#{bin}/datree version")
  end
end
