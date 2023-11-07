class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://ghproxy.com/https://github.com/facebook/wangle/releases/download/v2023.10.30.00/wangle-v2023.10.30.00.tar.gz"
  sha256 "cd46e08eb43dbd7650bc2a40f9617c99127c6fd80d2c243b8e260460869fcb93"
  license "Apache-2.0"
  revision 1
  head "https://github.com/facebook/wangle.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ea261705a11956014d8d21d50f6e3f30c6e7f069efb705f60e9acdb7db2e9915"
    sha256 cellar: :any,                 arm64_ventura:  "a9999ce5b73dbdec92c481796841b3236883b238d80ecc5975b403e66f093187"
    sha256 cellar: :any,                 arm64_monterey: "16be09850eec6bf6c707ac3e3d43f57d959e0473e3b9a46c8393cccfe1ff72fc"
    sha256 cellar: :any,                 sonoma:         "ac440defdbec3349c66412dd896dc2839087d182f03f6c5075e0bdd7fce54843"
    sha256 cellar: :any,                 ventura:        "a866245ac3a1d727e5a3b17672d637ce04bde5903ad636384bfd518347ed42b9"
    sha256 cellar: :any,                 monterey:       "106199a99ac051ba96030d8d426aa5b82e1a9a3cd62ca8e330e5966eec7df367"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d005889c9228aedbf0a5fd659e9419156b9323151ebfd289281d08b685c6ae37"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "double-conversion"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "libsodium"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "snappy"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  fails_with gcc: "5"

  def install
    cd "wangle" do
      system "cmake", ".", "-DBUILD_TESTS=OFF", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
      system "make", "install"
      system "make", "clean"
      system "cmake", ".", "-DBUILD_TESTS=OFF", "-DBUILD_SHARED_LIBS=OFF", *std_cmake_args
      system "make"
      lib.install "lib/libwangle.a"

      pkgshare.install Dir["example/echo/*.cpp"]
    end
  end

  test do
    cxx_flags = %W[
      -std=c++17
      -I#{include}
      -I#{Formula["openssl@3"].opt_include}
      -L#{Formula["gflags"].opt_lib}
      -L#{Formula["glog"].opt_lib}
      -L#{Formula["folly"].opt_lib}
      -L#{Formula["fizz"].opt_lib}
      -L#{lib}
      -lgflags
      -lglog
      -lfolly
      -lfizz
      -lwangle
    ]
    if OS.linux?
      cxx_flags << "-L#{Formula["boost"].opt_lib}"
      cxx_flags << "-lboost_context-mt"
      cxx_flags << "-ldl"
      cxx_flags << "-lpthread"
    end

    system ENV.cxx, pkgshare/"EchoClient.cpp", *cxx_flags, "-o", "EchoClient"
    system ENV.cxx, pkgshare/"EchoServer.cpp", *cxx_flags, "-o", "EchoServer"

    port = free_port
    fork { exec testpath/"EchoServer", "-port", port.to_s }
    sleep 10

    require "pty"
    output = ""
    PTY.spawn(testpath/"EchoClient", "-port", port.to_s) do |r, w, pid|
      w.write "Hello from Homebrew!\nAnother test line.\n"
      sleep 20
      Process.kill "TERM", pid
      begin
        r.each_line { |line| output += line }
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end
    assert_match("Hello from Homebrew!", output)
    assert_match("Another test line.", output)
  end
end
