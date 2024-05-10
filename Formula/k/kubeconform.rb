class Kubeconform < Formula
  desc "FAST Kubernetes manifests validator, with support for Custom Resources!"
  homepage "https://github.com/yannh/kubeconform"
  url "https://mirror.ghproxy.com/https://github.com/yannh/kubeconform/archive/refs/tags/v0.6.5.tar.gz"
  sha256 "b66031bd32e9db16315e7e3164afb0ef5d8e4a13769f90baeb76516bd07cd280"
  license "Apache-2.0"
  head "https://github.com/yannh/kubeconform.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "898bd9968dd1a2d133d16e31050568bbff32821f627cbdbed19c4b3d260ecff1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1328ca45d0d28c7aa83a24b2a854c7b2c055ec747ea1da5ee3f795601d92b8fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ddd61736a1373db73e427ec2fc04bc1fb617af1f43740df8dd4839d61a1e422"
    sha256 cellar: :any_skip_relocation, sonoma:         "52ee17ff59b37a6a058f2ca10d63cefd6da86fa88bc90d8fb7fc0f5add6aae63"
    sha256 cellar: :any_skip_relocation, ventura:        "6d1593bb3f2fb177dd7c90c32bbc08ad67db75f516b76d6afab0afe5845207f4"
    sha256 cellar: :any_skip_relocation, monterey:       "925b4b078d564c9ebba8c3c71144c2fb734f6df4699a70b2c356ce2381cf315f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5460469288dc9480080fb170c23d4450ce48a5478b74236c4d321adb30a99538"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/kubeconform"

    (pkgshare/"examples").install Dir["fixtures/*"]
  end

  test do
    cp_r pkgshare/"examples/.", testpath

    system bin/"kubeconform", testpath/"valid.yaml"
    assert_equal 0, $CHILD_STATUS.exitstatus

    assert_match "ReplicationController bob is invalid",
      shell_output("#{bin}/kubeconform #{testpath}/invalid.yaml", 1)
  end
end
