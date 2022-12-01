class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.122.0",
      revision: "b7686d461b6177a9c4ef93c99e00344b78cc4c41"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b88e8809f88182515732d015bb233d4c96d40dd5442c7903e5421aec051d4d2e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0959c9eed210c8852611135c15288b3fcd88bea588409a1deebbf5ac2b0b6265"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "259ca51c28c27091487bf26354b439159076d484bc4f3f62454a371b27b457ed"
    sha256 cellar: :any_skip_relocation, ventura:        "71c1b77fae1c63c980982b292e69a97265844fcb461bf260c8f4eec33fbe3b9e"
    sha256 cellar: :any_skip_relocation, monterey:       "78bcbb8f3275cf466708b785612cceeea6a8979f41e5445a13299028d5d9a709"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ace4b3d7c39be65618fef2a427535589fc83d92b3c12deb341e2ef5b0fce63a"
    sha256 cellar: :any_skip_relocation, catalina:       "3ff8428b77f0dfcf03f296be30af51741a29b3f431ccb7c997c09f92f017ce21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d147681b07cc71531c16823c17df625fdbe51c60684815b3eefa479fe5e52876"
  end

  depends_on "counterfeiter" => :build
  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "mockery" => :build
  depends_on "aws-iam-authenticator"

  # Eksctl requires newer version of ifacemaker
  #
  # Replace with `depends_on "ifacemaker" => :build` when ifacemaker > 1.2.0
  # Until then get the resource version from go.mod
  resource "ifacemaker" do
    url "https://github.com/vburenin/ifacemaker/archive/b2018d8549dc4d51ce7e2254d6b0a743643613be.tar.gz"
    sha256 "41888bf97133b4e7e190f2040378661b5bcab290d009e1098efbcb9db0f1d82f"
  end

  def install
    resource("ifacemaker").stage do
      system "go", "build", *std_go_args(ldflags: "-s -w", output: buildpath/"ifacemaker")
    end
    inreplace "build/scripts/generate-aws-interfaces.sh", "${GOBIN}/ifacemaker",
                                                          buildpath/"ifacemaker"

    ENV["GOBIN"] = HOMEBREW_PREFIX/"bin"
    ENV.deparallelize # Makefile prerequisites need to be run in order
    system "make", "build"
    bin.install "eksctl"

    generate_completions_from_executable(bin/"eksctl", "completion")
  end

  test do
    assert_match "The official CLI for Amazon EKS",
      shell_output("#{bin}/eksctl --help")

    assert_match "Error: couldn't create node group filter from command line options: --cluster must be set",
      shell_output("#{bin}/eksctl create nodegroup 2>&1", 1)
  end
end
