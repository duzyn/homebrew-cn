class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https://www.kubevpn.dev"
  url "https://mirror.ghproxy.com/https://github.com/kubenetworks/kubevpn/archive/refs/tags/v2.7.14.tar.gz"
  sha256 "47e2e43074714a79ecb97bf6c95bd7fd70a44d4f0669d430e5c0f20301f8ac40"
  license "MIT"
  head "https://github.com/kubenetworks/kubevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4760280c8451087a98ce9f49636b185d777ef296cd257846894a9c0dc2240879"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c118b92aa0bd9e5a27cb5e1ab3fe1209ad877c59817e496203b2a228a00badda"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "540f0779a874eed0d0feec109e07ade1f8eeca9d556ca36f9ca1d429cd4ae03f"
    sha256 cellar: :any_skip_relocation, sonoma:        "855f13302339f724e4896a2b9302c80f81123f38c4d9ef10a8bf5e5417b0f61f"
    sha256 cellar: :any_skip_relocation, ventura:       "859ba882fb3df0223381f57b1983a1cdd89c3993d68b47fa71ada202c31e59e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d227371485fcbfcc50877bab170911b8e0fb6e8cf53aa5b6a0d8c26e5b05a989"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bbdd97a965994a72e56ba6ab89feded69663bcde68474fe2c2b8699531bcfd0"
  end

  depends_on "go" => :build

  def install
    goos = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOOS").chomp
    goarch = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOARCH").chomp
    project = "github.com/wencaiwulue/kubevpn/v2"
    ldflags = %W[
      -s -w
      -X #{project}/pkg/config.Image=ghcr.io/kubenetworks/kubevpn:v#{version}
      -X #{project}/pkg/config.Version=v#{version}
      -X #{project}/pkg/config.GitCommit=brew
      -X #{project}/cmd/kubevpn/cmds.BuildTime=#{time.iso8601}
      -X #{project}/cmd/kubevpn/cmds.Branch=master
      -X #{project}/cmd/kubevpn/cmds.OsArch=#{goos}/#{goarch}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/kubevpn"

    generate_completions_from_executable(bin/"kubevpn", "completion")
  end

  test do
    assert_match "Version: v#{version}", shell_output("#{bin}/kubevpn version")
    assert_path_exists testpath/".kubevpn/config.yaml"
    assert_path_exists testpath/".kubevpn/daemon"
  end
end
