class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https://www.kubevpn.dev"
  url "https://mirror.ghproxy.com/https://github.com/kubenetworks/kubevpn/archive/refs/tags/v2.7.16.tar.gz"
  sha256 "24c7728797fb614c0fd69fcd878b872835d889cf25e8a140898a107f282ff999"
  license "MIT"
  head "https://github.com/kubenetworks/kubevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac2395e02e81af21f87dd085cc85a663282c488b2f57c1c5e433669ead10cef5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "086c2964d93d8402990573d7c3d81e641a1cd89be8f9920c771908270d714300"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e37474c7b318407b636c631d32ebb1aa4ef17245dcb27a34dd639a07f5a302d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b9e6d4214c7c8daa4a81ec03820053a5119de97ee05d9ebecba80c600a52f81"
    sha256 cellar: :any_skip_relocation, ventura:       "e95b1a2579d4fcb2b2a58ca0f5d3182ba748150a630d52271b73603cf917f45c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "776d92e37824f8b7b3e1c047b5f6fd22de820b70d77973e072a6ec925c40777a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e7b8fab02411ba6b54360a5e5593e74bdeb1b0dcc79beaf135f2c5fe12d47b8"
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
