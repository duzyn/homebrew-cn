class Redis < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://download.redis.io/releases/redis-7.0.6.tar.gz"
  sha256 "7b33a7e890d13e27af1f246acb16312669ad8a1d56ce8f807dfbcd3c09aa7bb3"
  license "BSD-3-Clause"
  head "https://github.com/redis/redis.git", branch: "unstable"

  livecheck do
    url "https://download.redis.io/releases/"
    regex(/href=.*?redis[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d6871708dfbae5e2575e3a1c2463549688baef814fb2451a9f6752ed5f26bd52"
    sha256 cellar: :any,                 arm64_monterey: "fab34949b18f10dd29ee058ee266e5bcc00e83e1cd84bcb2a63dae30f32bcc1e"
    sha256 cellar: :any,                 arm64_big_sur:  "2e532087435e2fc0ea3105b7abc95388dc7c1cb630aa2f8558f9681bb77cc93b"
    sha256 cellar: :any,                 ventura:        "945ca3b3b0a41c3dacdba3eb7a8301831a06706dc41a686ceadac5e70bcc6601"
    sha256 cellar: :any,                 monterey:       "d8db070dfce9a2faba31ca3d628c7c95717b4b012729f777292dacdf2c7d5c00"
    sha256 cellar: :any,                 big_sur:        "838f774265186892e89573b08409b858387b2f8394fcea811d0a6f6b4f632889"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb63211f7cca3d508d1a462cbe427d4186da09d0446581a74c12305ebfe5a1e5"
  end

  depends_on "openssl@1.1"

  def install
    system "make", "install", "PREFIX=#{prefix}", "CC=#{ENV.cc}", "BUILD_TLS=yes"

    %w[run db/redis log].each { |p| (var/p).mkpath }

    # Fix up default conf file to match our paths
    inreplace "redis.conf" do |s|
      s.gsub! "/var/run/redis.pid", var/"run/redis.pid"
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
    %w[run db/redis log].each { |p| assert_predicate var/p, :exist?, "#{var/p} doesn't exist!" }
  end
end
