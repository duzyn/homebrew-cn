class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "3.39",
      revision: "51d4a4b28d0edcd01ab1faa19f8a80f4137fc497"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d36d747600ecd0d28a02897e87f711682a4b963c891b2e56da12e983a22aab72"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb292df51b3aa026203e9ed889b20a88cda017a76339db74fdc0f65d08a03e43"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bccc2fda1174db70164002b8e050671d64cd479509d36c3dba6bdc7cb817b869"
    sha256 cellar: :any_skip_relocation, ventura:        "a2ad68ad0ffa13492955b7cde7f9b4bd61bcf926dbf1037c026485727a8731d8"
    sha256 cellar: :any_skip_relocation, monterey:       "0983e8ec68d907c27990ede31d17efe0fd5a289ac7f97ee148db1e6bfda065aa"
    sha256 cellar: :any_skip_relocation, big_sur:        "8ebe7cb45f1e7031dd7c3b48aa8fd6887661dcd209f410a02712b4329a6a1569"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b5e5145f94b385b1d3b81efd9d2a0d2298a6877d2605ac3b9e64545e043bf0d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/seaweedfs/seaweedfs/weed/util.COMMIT=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(output: bin/"weed", ldflags: ldflags), "./weed"
  end

  test do
    # Start SeaweedFS master server/volume server
    master_port = free_port
    volume_port = free_port
    master_grpc_port = free_port
    volume_grpc_port = free_port

    fork do
      exec bin/"weed", "server", "-dir=#{testpath}", "-ip.bind=0.0.0.0",
           "-master.port=#{master_port}", "-volume.port=#{volume_port}",
           "-master.port.grpc=#{master_grpc_port}", "-volume.port.grpc=#{volume_grpc_port}"
    end
    sleep 30

    # Upload a test file
    fid = JSON.parse(shell_output("curl http://localhost:#{master_port}/dir/assign"))["fid"]
    system "curl", "-F", "file=@#{test_fixtures("test.png")}", "http://localhost:#{volume_port}/#{fid}"

    # Download and validate uploaded test file against the original
    expected_sum = Digest::SHA256.hexdigest(File.read(test_fixtures("test.png")))
    actual_sum = Digest::SHA256.hexdigest(shell_output("curl http://localhost:#{volume_port}/#{fid}"))
    assert_equal expected_sum, actual_sum
  end
end
