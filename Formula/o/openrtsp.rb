class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2024.10.09.tar.gz"
  mirror "https://mirrors.aliyun.com/videolan/pub/videolan/testing/contrib/live555/live.2024.10.09.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "50ec095dd139eec52b1e4568751506379329297ab23a8f8f4c6aa5c1105c7a00"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http://www.live555.com/liveMedia/public/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ad7d433478560221fbd83dc3fbc34636ba77454dda8214ca2b2071dce6a1589a"
    sha256 cellar: :any,                 arm64_sonoma:  "3545c4a0abc64bd726d4266e01cf048eef53d6a3230711db13902f4de1677b10"
    sha256 cellar: :any,                 arm64_ventura: "7515ec2ce35b61e93c158ebf624f859b8497ace2d77f301949b4149e3ff6d234"
    sha256 cellar: :any,                 sonoma:        "e53a94d8c55c21f409a5bb07c155e02a886ec5b946ba97db1d52ccfc594a0286"
    sha256 cellar: :any,                 ventura:       "b3fec38aa43aba821946a56c35db96afa0ee8ad33316251366ca814af060bd2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8362e77e63bcf79688f5eab4a5db2f0276f36ea1aa650bed212fe780e396201d"
  end

  depends_on "openssl@3"

  # Support CXXFLAGS when building on macOS
  # PR ref: https://github.com/rgaufman/live555/pull/46
  # TODO: Remove once changes land in a release
  patch do
    url "https://github.com/rgaufman/live555/commit/16701af5486bb3a2d25a28edaab07789c8a9ce57.patch?full_index=1"
    sha256 "2d98a782081028fe3b7daf6b2db19e99c46f0cadab2421745de907146a3595cb"
  end

  def install
    # "test" was added to std::atomic_flag in C++20
    # See https://github.com/rgaufman/live555/issues/45
    ENV.append "CXXFLAGS", "-std=c++20"

    # Avoid linkage to system OpenSSL
    libs = [
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
    ]

    os_flag = OS.mac? ? "macosx-bigsur" : "linux"
    system "./genMakefiles", os_flag
    system "make", "PREFIX=#{prefix}",
           "LIBS_FOR_CONSOLE_APPLICATION=#{libs.join(" ")}", "install"

    # Move the testing executables out of the main PATH
    libexec.install Dir.glob(bin/"test*")
  end

  def caveats
    <<~EOS
      Testing executables have been placed in:
        #{libexec}
    EOS
  end

  test do
    assert_match "GNU", shell_output("#{bin}/live555ProxyServer 2>&1", 1)
  end
end
