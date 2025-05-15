class Redis < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://download.redis.io/releases/redis-8.0.1.tar.gz"
  sha256 "d3a11d6ababf44cb98d23f23cee39ae75d17867dcd64aac4add808e21ed36e0c"
  license all_of: [
    "AGPL-3.0-only",
    "BSD-2-Clause", # deps/jemalloc, deps/linenoise, src/lzf*
    "BSL-1.0", # deps/fpconv
    "MIT", # deps/lua
    any_of: ["CC0-1.0", "BSD-2-Clause"], # deps/hdr_histogram
  ]
  head "https://github.com/redis/redis.git", branch: "unstable"

  livecheck do
    url "https://download.redis.io/releases/"
    regex(/href=.*?redis[._-]v?(\d+(?:\.\d+)+)\.t/i)
    strategy :page_match
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7f257283869f97ce45045f0f049c27e2a79b686d0ac58458360b6a00c2d75f34"
    sha256 cellar: :any,                 arm64_sonoma:  "07deb17bfdf5a0668972ed574e36ae4d66cc613b3cbec6edff7c893adb331767"
    sha256 cellar: :any,                 arm64_ventura: "b02cc3ee192fbcb6c1b8cc7437e1352c15d517304d05415586444d00fd9617b4"
    sha256 cellar: :any,                 sonoma:        "73ec7300890dc545e73bba6986cce8709cbc274c3d20b2c3e35ba5660318c603"
    sha256 cellar: :any,                 ventura:       "4d00b36d282062de2c494e61ae2431ff404d93e641c22d52cfe19b1bf7512181"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78795b13b7e57f9acd185d2db76a135d0e7f182da92d643e69598c2abd1577e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a43fc666a8b8551036c82f6a7e10f84acfc7024a70e7ea542c244768c6397041"
  end

  depends_on "openssl@3"

  conflicts_with "valkey", because: "both install `redis-*` binaries"

  def install
    system "make", "install", "PREFIX=#{prefix}", "CC=#{ENV.cc}", "BUILD_TLS=yes"

    %w[run db/redis log].each { |p| (var/p).mkpath }

    # Fix up default conf file to match our paths
    inreplace "redis.conf" do |s|
      s.gsub! "/var/run/redis_6379.pid", var/"run/redis.pid"
      s.gsub! "dir ./", "dir #{var}/db/redis/"
      s.sub!(/^bind .*$/, "bind 127.0.0.1 ::1")
    end

    etc.install "redis.conf"
    etc.install "sentinel.conf" => "redis-sentinel.conf"
  end

  service do
    run [opt_bin/"redis-server", etc/"redis.conf"]
    keep_alive true
    error_log_path var/"log/redis.log"
    log_path var/"log/redis.log"
    working_dir var
  end

  test do
    system bin/"redis-server", "--test-memory", "2"
    %w[run db/redis log].each { |p| assert_path_exists var/p, "#{var/p} doesn't exist!" }
  end
end
