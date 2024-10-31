class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https://www.kubevpn.cn"
  url "https://mirror.ghproxy.com/https://github.com/kubenetworks/kubevpn/archive/refs/tags/v2.2.22.tar.gz"
  sha256 "a3e5e07cbe21d328858d2ea6256000f82ab59241943a2368d366c0e8d1628a91"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9256c8352d51cb68ea996cbbf592ac700ccd9c1a4057032fd190162a7c997b51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd3b90736c39f83db80d6770d5006eaf5965efeaebe7acd80477567f145a0502"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "28f18a3a700e6659391c51d79931ead2b02c536dca73bd3abb008b72c21b443e"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab97ca75b32a64ff87d75343b9cbbebde11b38567150e3234284b41081f0cc03"
    sha256 cellar: :any_skip_relocation, ventura:       "b2c9f250bed1fa0bb8dc76b270d0ca0c9ffc3c18fb5889f4b7dc11f414304f71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d6fd9c9ac22da5574661a5e7c51ab6f122d7ef9503146a6e0d08b00a069ee47"
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
