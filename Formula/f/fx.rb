class Fx < Formula
  desc "Terminal JSON viewer"
  homepage "https://fx.wtf"
  url "https://ghproxy.com/https://github.com/antonmedv/fx/archive/refs/tags/30.0.2.tar.gz"
  sha256 "8ac17c5fd0beecbd9e94b8a8a0af8ed93111a66afe55b596d9fcd032f73f9365"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17595074c5b45880576e6a3389cfe871fb398cc6eaec00714a931d5c4bbed4d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17595074c5b45880576e6a3389cfe871fb398cc6eaec00714a931d5c4bbed4d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "17595074c5b45880576e6a3389cfe871fb398cc6eaec00714a931d5c4bbed4d0"
    sha256 cellar: :any_skip_relocation, ventura:        "c5f49eebbfed18c3ddd8800d6df4aa947450073f4d72bc74931ca5c3349531ea"
    sha256 cellar: :any_skip_relocation, monterey:       "c5f49eebbfed18c3ddd8800d6df4aa947450073f4d72bc74931ca5c3349531ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "c5f49eebbfed18c3ddd8800d6df4aa947450073f4d72bc74931ca5c3349531ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c385ce313c505e95cd3a0e66292b3737861381140a95d0485e107e87ad4989a"
  end

  depends_on "go" => :build
  depends_on "node"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_equal "42", pipe_output("#{bin}/fx .", 42).strip
  end
end
