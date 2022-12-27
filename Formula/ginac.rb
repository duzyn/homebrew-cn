class Ginac < Formula
  desc "Not a Computer algebra system"
  homepage "https://www.ginac.de/"
  url "https://www.ginac.de/ginac-1.8.4.tar.bz2"
  sha256 "27ce16aedfe74651b223bdb9246c00596b7ff9bf727a0d3a473f467000dac492"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.ginac.de/Download.html"
    regex(/href=.*?ginac[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 ventura:      "d0d01875665d8758c7c368456a78c0efea7dbada82b24d1dd485501987148199"
    sha256 cellar: :any,                 monterey:     "b2c0addbf423960718626d2794551a81aa0dd23b5dd51d8b3f649d7db76875e9"
    sha256 cellar: :any,                 big_sur:      "bcacb74a4fb65f5acfeb189bfc1af3beca7b499118d1edc2df0ffb1dd0b3b16b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "78d5317a03a3245e1b603cc2c15251a6d660d9fab5cbddc3577b8d9dce9cee4f"
  end

  depends_on "pkg-config" => :build
  depends_on "cln"
  depends_on "python@3.11"
  depends_on "readline"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <ginac/ginac.h>
      using namespace std;
      using namespace GiNaC;

      int main() {
        symbol x("x"), y("y");
        ex poly;

        for (int i=0; i<3; ++i) {
          poly += factorial(i+16)*pow(x,i)*pow(y,2-i);
        }

        cout << poly << endl;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}",
                                "-L#{Formula["cln"].lib}",
                                "-lcln", "-lginac", "-o", "test",
                                "-std=c++11"
    system "./test"
  end
end
