class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "3.38",
      revision: "48f2edc06503d9a915fe8eb4cecbfc83f1467ce9"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a48c320ad5b0f61b98b386cfd412fa7aa272252b401b3d65b5f46c6ffedceba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34c52b1e7a6e2a588b5febb220e6ea98c9979cd4777473d726794d6fd31c9424"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1c8958eed6b4ec69e9b1f41b78939e6a38e657df23c0f278b88b98e98bfea59b"
    sha256 cellar: :any_skip_relocation, ventura:        "2155855d4e3dab172314a3821b69420dafd5ba101dfbf582f87d9705832c2cff"
    sha256 cellar: :any_skip_relocation, monterey:       "91a7945c518227e60dc8dcacff6c58b903cc8dd563786f52c7b27fedd392cccb"
    sha256 cellar: :any_skip_relocation, big_sur:        "6add90eebdeb866a71b5920380e816f212f893f55ee31d6b0d0fef09e4b45adf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4dcbf4b27d63c0845d51effa0373a2376362d31647b282b7ef7781a98af6c9d7"
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
