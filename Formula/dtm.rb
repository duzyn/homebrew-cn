class Dtm < Formula
  desc "Cross-language distributed transaction manager"
  homepage "https://en.dtm.pub/"
  url "https://github.com/dtm-labs/dtm/archive/refs/tags/v1.16.6.tar.gz"
  sha256 "d9b6fa694c506c6b17ee221698ee25e6360555cfd8737483154cedbbdc7cc7b1"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac1da1b6a5306890eed23f63b311fcc1dce54e62e750ac32cefb1b4c17ae8cb6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1c1af5ed6ad5c7d852a871fd15741b2221d4e9674c15bbbe6a7701ee9776682"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e5e4a568b27257f1407c014f602ae9023dea504b16f342566e6544ed34cbefaf"
    sha256 cellar: :any_skip_relocation, ventura:        "6cfc4940b36cd2534efa09c74a83a73ad9ed73acacb8af2e46a56304476ebf10"
    sha256 cellar: :any_skip_relocation, monterey:       "aace3f54aaf9e6fce7044cc4bf46022ba6a3a48049c2db126cd636757870690d"
    sha256 cellar: :any_skip_relocation, big_sur:        "cb283b159268269f2b900bf13b1a15a91d0352cd4dc014721bc8c504d43d79e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "302d4f3f51823d347aa2c34062eedea9a8e0404ca77d4d9c2f08604512da07ff"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=v#{version}")
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"dtm-qs"), "qs/main.go"
  end

  test do
    assert_match "dtm version: v#{version}", shell_output("#{bin}/dtm -v")

    http_port = free_port
    grpc_port = free_port

    dtm_pid = fork do
      ENV["HTTP_PORT"] = http_port.to_s
      ENV["GRPC_PORT"] = grpc_port.to_s
      exec bin/"dtm"
    end
    # sleep to let dtm get its wits about it
    sleep 5
    metrics_output = shell_output("curl -s localhost:#{http_port}/api/metrics")
    assert_match "# HELP dtm_server_info The information of this dtm server.", metrics_output

    all_json = JSON.parse(shell_output("curl -s localhost:#{http_port}/api/dtmsvr/all"))
    assert_equal 0, all_json["next_position"].length
    assert all_json["next_position"].instance_of? String
    assert_equal 0, all_json["transactions"].length
    assert all_json["transactions"].instance_of? Array
  ensure
    # clean up the dtm process before we leave
    Process.kill("HUP", dtm_pid)
  end
end
