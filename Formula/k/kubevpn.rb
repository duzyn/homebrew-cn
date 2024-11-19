class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https://www.kubevpn.cn"
  url "https://mirror.ghproxy.com/https://github.com/kubenetworks/kubevpn/archive/refs/tags/v2.3.2.tar.gz"
  sha256 "10861ca4fd0c3e78f6fdd801ca2e222a001cd46dca33b6b0bece123abba880d9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54f86a5d26d7ead17c700730ea1ef3014ab029515866a0718b92fc689be56e67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7fefd0697907457377a972a556d53800902d0e1acbc123cc29c649fb147a67c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6f68b68e3d8fd5b6f99b92e7a5a50b55ca4ab9bb20775470cef4380cc1f1de49"
    sha256 cellar: :any_skip_relocation, sonoma:        "49866eea655d8d940dbea7de8660b98cc6c1de8621a3e31e937037681f716dfb"
    sha256 cellar: :any_skip_relocation, ventura:       "5fec6e17be7439fb73bdd21ce4f64b599ace862e4be9a82a2393111cf544ee79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ec548205b53610900acb82dc817fbd99809869c8d098e64ee5e8e7bae42ed1e"
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
