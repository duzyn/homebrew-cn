class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https://www.kubevpn.cn"
  url "https://mirror.ghproxy.com/https://github.com/kubenetworks/kubevpn/archive/refs/tags/v2.3.3.tar.gz"
  sha256 "304641f28e6f761c7180472d9681dcb1f793a2e3822f1193708b795cfa1427b2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a26490acfa15c9bb523ab9cd83e5f939aefc1088ac81bbae4c076da50d8fff6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "135fa1ef1cec46f643e927b58f98f91fcd94f3a1896ee11540ec054327dda856"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e2975b9c86623859873acefc11d1399d6164bfcd23cc9e090036692e30bc690d"
    sha256 cellar: :any_skip_relocation, sonoma:        "293fe6df343292c78db2b1d428f2d3ef3b69502e7047b045227f2012d49cb6d4"
    sha256 cellar: :any_skip_relocation, ventura:       "bb9007ccf7614c28170260d0a0cf851f277d4928fac010fe44140e35d3b00f06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78ce74b527fcca2172b1e6d8e6496adec8000ea2d042fbc076f2acea1fbc9093"
  end

  depends_on "go" => :build

  def install
    goos = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOOS").chomp
    goarch = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOARCH").chomp
    tags = "noassets"
    project = "github.com/wencaiwulue/kubevpn/v2"
    ldflags = %W[
      -s -w
      -X #{project}/pkg/config.Image=docker.io/naison/kubevpn:v#{version}
      -X #{project}/pkg/config.Version=v#{version}
      -X #{project}/pkg/config.GitCommit=brew
      -X #{project}/cmd/kubevpn/cmds.BuildTime=#{time.iso8601}
      -X #{project}/cmd/kubevpn/cmds.Branch=master
      -X #{project}/cmd/kubevpn/cmds.OsArch=#{goos}/#{goarch}
    ]
    system "go", "build", *std_go_args(ldflags:), "-tags", tags, "./cmd/kubevpn"

    generate_completions_from_executable(bin/"kubevpn", "completion")
  end

  test do
    assert_match "Version: v#{version}", shell_output("#{bin}/kubevpn version")
    assert_predicate testpath/".kubevpn/config.yaml", :exist?
    assert_predicate testpath/".kubevpn/daemon", :exist?
  end
end
