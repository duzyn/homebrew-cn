class Etl < Formula
  desc "Extensible Template Library"
  homepage "https://synfig.org"
  url "https://downloads.sourceforge.net/project/synfig/development/1.5.1/ETL-1.5.1.tar.gz?use_mirror=jaist"
  mirror "https://mirror.ghproxy.com/https://github.com/synfig/synfig/releases/download/v1.5.1/ETL-1.5.1.tar.gz"
  sha256 "125c04f1892f285febc2f9cc06f932f7708e3c9f94c3a3004cd1803197197b4a"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/ETL[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "bb6edd499e2137dd8d238351cbf327885a99da4470c5d66c81ba670ac8b660e9"
  end

  depends_on "pkg-config" => :build
  depends_on "glibmm@2.66"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <ETL/misc>
      int main(int argc, char *argv[])
      {
        int rv = etl::ceil_to_int(5.5);
        return 6 - rv;
      }
    EOS
    flags = %W[
      -I#{include}/ETL
      -lpthread
    ]
    system ENV.cxx, "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
