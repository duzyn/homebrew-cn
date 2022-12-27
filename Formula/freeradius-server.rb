class FreeradiusServer < Formula
  desc "High-performance and highly configurable RADIUS server"
  homepage "https://freeradius.org/"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  head "https://github.com/FreeRADIUS/freeradius-server.git", branch: "master"

  stable do
    url "https://github.com/FreeRADIUS/freeradius-server/archive/refs/tags/release_3_2_1.tar.gz"
    sha256 "95c18c5489564b5a07ef5e64f6685dbe1415f690ceb46f0706d422b8e8a29b52"

    # Fix -flat_namespace being used
    patch do
      url "https://github.com/FreeRADIUS/freeradius-server/commit/6c1cdb0e75ce36f6fadb8ade1a69ba5e16283689.patch?full_index=1"
      sha256 "7e7d055d72736880ca8e1be70b81271dd02f2467156404280a117cb5dc8dccdc"
    end
  end

  livecheck do
    url :stable
    regex(/^release[._-](\d+(?:[._]\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "09ed308f985340dc1cc10901ad2b27c1e149b976d5979cc9d41da13c93790d67"
    sha256 arm64_monterey: "141c22bdec2415890a785f60d369f97366f849da76e85f7047003e4716d6b117"
    sha256 arm64_big_sur:  "f22d42aace56a5a88bd153898009d293d772b456bb8264386a01d1500da00afa"
    sha256 ventura:        "90b413381732b3a23034af48e299e58a26efc28f7da2c9b0da794ea46cd7bf81"
    sha256 monterey:       "3c9a1b338ba21bde1216fcb76ae46ac3950fcc1541455bb9f72ae5082101fe7e"
    sha256 big_sur:        "f65e5197ed78de8ea179c2cd6633a04498470c53b7b3c8d10474a1d2cc08c7c4"
    sha256 x86_64_linux:   "53b0e8030372c73986ec6b700506f52ec96598a2af902b2ca48656afcdc6f7a2"
  end

  depends_on "collectd"
  depends_on "openssl@1.1"
  depends_on "python@3.11"
  depends_on "talloc"

  uses_from_macos "krb5"
  uses_from_macos "libpcap"
  uses_from_macos "libxcrypt"
  uses_from_macos "perl"
  uses_from_macos "sqlite"

  on_linux do
    depends_on "readline"
  end

  def install
    ENV.deparallelize

    args = %W[
      --prefix=#{prefix}
      --sbindir=#{bin}
      --localstatedir=#{var}
      --with-openssl-includes=#{Formula["openssl@1.1"].opt_include}
      --with-openssl-libraries=#{Formula["openssl@1.1"].opt_lib}
      --with-talloc-lib-dir=#{Formula["talloc"].opt_lib}
      --with-talloc-include-dir=#{Formula["talloc"].opt_include}
    ]

    args << "--without-rlm_python" if OS.mac?

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  def post_install
    (var/"run/radiusd").mkpath
    (var/"log/radius").mkpath
  end

  test do
    output = shell_output("#{bin}/smbencrypt homebrew")
    assert_match "77C8009C912CFFCF3832C92FC614B7D1", output
  end
end
