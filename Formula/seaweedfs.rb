class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "3.36",
      revision: "fad7e1f7cbec0368f4f872154668daa0a7f6ed03"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3929508de82768fe718ec09010a03f812fe41d30e920efbd3935a22e433ee9f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a38e933c8cb332d487101dddfa2d7f53d57b6fae0402d70d97084ddf17235e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e432b5e4b993469dda179c6fd6b7811a7c664e81df7bbe2ddf79352e4cf03162"
    sha256 cellar: :any_skip_relocation, ventura:        "294503f38008ec6635cf4be438ca38f422e0de4304a9eb50626449fb3c31e66e"
    sha256 cellar: :any_skip_relocation, monterey:       "918224dd6cfb065f824382eac384dec3a53edeb584cb95729a5d7919ca70b873"
    sha256 cellar: :any_skip_relocation, big_sur:        "cd83fb138e5a4fd440cce55139915b890836a71d42f5a24227acb28ac4db8582"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "837ec8ad1fb3f9f51810b29cf7a173a20a88931c33a9dbddb1af70069114492c"
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
