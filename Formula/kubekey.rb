class Kubekey < Formula
  desc "Installer for Kubernetes and / or KubeSphere, and related cloud-native add-ons"
  homepage "https://kubesphere.io"
  url "https://github.com/kubesphere/kubekey.git",
      tag:      "v3.0.3",
      revision: "fab5588dc6aa05d9b58778a8b355e049794f35d2"
  license "Apache-2.0"
  head "https://github.com/kubesphere/kubekey.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2c76a3b632ed321f3fc5dc35ed165693cb636a343bcd911aaef7411c0dec0f68"
    sha256 cellar: :any,                 arm64_monterey: "7a5790624f7c35548ba426c896338db85e6531b57247161a6992d8b6354888d0"
    sha256 cellar: :any,                 arm64_big_sur:  "25b5b81aa248c5ade8c198121cf9bcbe69239115b448f4b7c3731297e537ae0b"
    sha256 cellar: :any,                 ventura:        "4d5ce097445d64b926c5e5d93229ecbaae548f8fdb42f1ea3497337807a30208"
    sha256 cellar: :any,                 monterey:       "4de166ff5347486785e8000f40fcb538d09fed78fd98c3ea519509a11918dae7"
    sha256 cellar: :any,                 big_sur:        "d19cecc274ea64fb7e3d425972420b88825803f72d5cd77974596db44dca7bd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7e33c93056bea89a7fcf6429a8a9780ee08bf7a728573786f7a930d1bc1e3b8"
  end

  depends_on "go" => :build
  depends_on "gpgme"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "btrfs-progs"
    depends_on "device-mapper"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/kubesphere/kubekey/version.gitMajor=#{version.major}
      -X github.com/kubesphere/kubekey/version.gitMinor=#{version.minor}
      -X github.com/kubesphere/kubekey/version.gitVersion=v#{version}
      -X github.com/kubesphere/kubekey/version.gitCommit=#{Utils.git_head}
      -X github.com/kubesphere/kubekey/version.gitTreeState=clean
      -X github.com/kubesphere/kubekey/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"kk"), "./cmd/kk"

    generate_completions_from_executable(bin/"kk", "completion", "--type", shells: [:bash, :zsh], base_name: "kk")
  end

  test do
    version_output = shell_output(bin/"kk version")
    assert_match "Version:\"v#{version}\"", version_output
    assert_match "GitTreeState:\"clean\"", version_output

    system bin/"kk", "create", "config", "-f", "homebrew.yaml"
    assert_predicate testpath/"homebrew.yaml", :exist?
  end
end
