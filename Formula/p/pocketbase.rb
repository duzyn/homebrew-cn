class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://mirror.ghproxy.com/https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.23.3.tar.gz"
  sha256 "35eccd3b1e68bc50e8b0e69449b2ea0cd88523d30b36bb990550fb344ea1c8cc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c386b54d04c1f0bd40fdf4b1f6c847e93925c29cadadd3529120d527a45f5ba0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c386b54d04c1f0bd40fdf4b1f6c847e93925c29cadadd3529120d527a45f5ba0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c386b54d04c1f0bd40fdf4b1f6c847e93925c29cadadd3529120d527a45f5ba0"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ad31e8b5eefef89dbfc6300add2a822d1ff43fd046cfdbfc37e333b9a96d115"
    sha256 cellar: :any_skip_relocation, ventura:       "2ad31e8b5eefef89dbfc6300add2a822d1ff43fd046cfdbfc37e333b9a96d115"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f4dcb42c676dd59efafa67cd573788f3b40019bc5e0aa39fd1be80f5299fa04"
  end

  depends_on "go" => :build

  uses_from_macos "netcat" => :test

  def install
    ENV["CGO_ENABLED"] = "0"

    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/pocketbase/pocketbase.Version=#{version}"), "./examples/base"
  end

  test do
    assert_match "pocketbase version #{version}", shell_output("#{bin}/pocketbase --version")

    port = free_port
    _, _, pid = PTY.spawn("#{bin}/pocketbase serve --dir #{testpath}/pb_data --http 127.0.0.1:#{port}")
    sleep 5

    system "nc", "-z", "localhost", port

    assert_predicate testpath/"pb_data", :exist?, "pb_data directory should exist"
    assert_predicate testpath/"pb_data", :directory?, "pb_data should be a directory"

    assert_predicate testpath/"pb_data/data.db", :exist?, "pb_data/data.db should exist"
    assert_predicate testpath/"pb_data/data.db", :file?, "pb_data/data.db should be a file"

    assert_predicate testpath/"pb_data/auxiliary.db", :exist?, "pb_data/auxiliary.db should exist"
    assert_predicate testpath/"pb_data/auxiliary.db", :file?, "pb_data/auxiliary.db should be a file"
  ensure
    Process.kill "TERM", pid
  end
end
