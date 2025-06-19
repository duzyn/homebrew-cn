class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https://www.kubevpn.dev"
  url "https://mirror.ghproxy.com/https://github.com/kubenetworks/kubevpn/archive/refs/tags/v2.7.19.tar.gz"
  sha256 "4277b20cabc0667e9ca2be89f000bc740819839e59f8c3b56c4987d68c2fa4c4"
  license "MIT"
  head "https://github.com/kubenetworks/kubevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10d434797f5c307759ed3ea1986f1989c2c944d8381a6694a88d0fb9914f96d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d898983b55842e2f55a5f8124cd7a71ce302b64d3e6d94fa4220e64183e02ce8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "19319a1baa5865b7075b1be4930067940c15b08f4b894fd4830265a8b2cc1d9b"
    sha256 cellar: :any_skip_relocation, sonoma:        "4735055a8b2ee0dd71d2c1e6d148c1ffa49f14c4f7c36339e4508d196b80a696"
    sha256 cellar: :any_skip_relocation, ventura:       "dfbc79dff6ee6ebd53d8c4c1f8c03dc67af6e35c14f0522be5c4ba9da72112ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4311ec5028a17bb4a0cdd60f2c6142f2b6dec8199ad311e686ea1de75f6ffdc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76709c9df17e465571d221acc5de0598e7658a784d96b2dfda38b672f24a77f8"
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
