class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.2.2/ortp-5.2.2.tar.bz2"
  sha256 "3e43a10cdadcd82f10cc1953f368acf381cb6783b68371203499d8af8e65cc33"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7131d9d5840e6f3e4b9546d3c896b8063821dd642a42f9e084f77e512b6f9b63"
    sha256 cellar: :any,                 arm64_monterey: "9d4849a111bdae388f2ed03426785971bbc5141883f8aae7a720629303db229b"
    sha256 cellar: :any,                 arm64_big_sur:  "afb84235337c302e605fe8246b2d89872c8a06412f3af54d7287170235b16418"
    sha256 cellar: :any,                 ventura:        "a1763cdb682a1296192bb721f5d558ca2ff0ae024c4ab5b37341b8d99677b15a"
    sha256 cellar: :any,                 monterey:       "b701f2e3b7d2da673130b6ef2d81939d639c28a18d0bae557b4024c4ad6da353"
    sha256 cellar: :any,                 big_sur:        "595d92f66f17ab81e57f4d923c32f22ca2a2dc691dc650065e24867588862a7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db4c73fd36f6c22b9103c6ba5a042d8cdbedde849a3979dec61e85177badd82b"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    # Don't forget to change both instances of the version in the URL.
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.2.2/bctoolbox-5.2.2.tar.bz2"
    sha256 "420269457b365f91a4834935798de54e8bd00500dffa8f03ee3545835de74cf0"
  end

  def install
    resource("bctoolbox").stage do
      system "cmake", "-S", ".", "-B", "build",
                      "-DENABLE_TESTS_COMPONENT=OFF",
                      *std_cmake_args(install_prefix: libexec)
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    ENV.prepend_path "PKG_CONFIG_PATH", libexec/"lib/pkgconfig"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{libexec}/lib" if OS.linux?
    cflags = ["-I#{libexec}/include"]
    cflags << "-Wno-error=maybe-uninitialized" if OS.linux?

    args = %W[
      -DCMAKE_PREFIX_PATH=#{libexec}
      -DCMAKE_C_FLAGS=#{cflags.join(" ")}
      -DCMAKE_CXX_FLAGS=-I#{libexec}/include
      -DENABLE_DOC=NO
      -DENABLE_UNIT_TESTS=NO
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "ortp/logging.h"
      #include "ortp/rtpsession.h"
      #include "ortp/sessionset.h"
      int main()
      {
        ORTP_PUBLIC void ortp_init(void);
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", "-I#{libexec}/include", "-L#{lib}", "-lortp",
           testpath/"test.c", "-o", "test"
    system "./test"

    # Ensure that bctoolbox's version is identical to ortp's.
    assert_equal version, resource("bctoolbox").version
  end
end
