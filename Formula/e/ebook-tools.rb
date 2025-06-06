class EbookTools < Formula
  desc "Access and convert several ebook formats"
  homepage "https://sourceforge.net/projects/ebook-tools/"
  url "https://downloads.sourceforge.net/project/ebook-tools/ebook-tools/0.2.2/ebook-tools-0.2.2.tar.gz?use_mirror=jaist"
  sha256 "cbc35996e911144fa62925366ad6a6212d6af2588f1e39075954973bbee627ae"
  license "MIT"
  revision 3

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "f5941a8ccff53411313a9126e9414bb6ee069ac5ac3b4ebf819d0b98bc757460"
    sha256 cellar: :any,                 arm64_sonoma:   "62256c5eb6880252f8110c8c35d9c84bd9838bce63de8af4377497d19da21d82"
    sha256 cellar: :any,                 arm64_ventura:  "019f7789541693a154f71bb507db24ab2cd3901f539e08e2ce2e51f53aae48da"
    sha256 cellar: :any,                 arm64_monterey: "ea1b7dcf30a98ec82dbe77c369168185565450ee4c4af8e4d77f9ae2ffaa360d"
    sha256 cellar: :any,                 arm64_big_sur:  "22676305647bc9cad4335aba2d28d27cbee0db6092901cf1682fff9c833c92bd"
    sha256 cellar: :any,                 sonoma:         "41661c88aedc2177a9fcd52926d45b3385724888e17b206f61ac8ee85f938ad7"
    sha256 cellar: :any,                 ventura:        "2bd78f9654202568c6d95821ca7d5f04a83859748a818b1234528993c5ba72e4"
    sha256 cellar: :any,                 monterey:       "64d14b86d0aa4270c9f918b1e8539100f6c2eb495ccc33a16e7bb7a322790328"
    sha256 cellar: :any,                 big_sur:        "e9c49bae08503eaf6e213454bd4f5ce58ead342ef192798c6d7d9c04fb6c2918"
    sha256 cellar: :any,                 catalina:       "65d014f4c91fec7b0d156a751b1e3b409574f3606264f8ae9ccab0a1db0f564f"
    sha256 cellar: :any,                 mojave:         "93400da1ecc27f229a5ae3b1d49f47f1779e148912c39bcd3955499b0eec84e5"
    sha256 cellar: :any,                 high_sierra:    "fce5577098322a2b4f6fd73a4a18077f77100adf1f15d9a494594e416354d1cc"
    sha256 cellar: :any,                 sierra:         "cc01e2bcdd26e6e9b0852e604f2bd56c31bde00ff42eb73fca45d2661fbab159"
    sha256 cellar: :any,                 el_capitan:     "aa76cbdcef93ac7d4af39b9cbcb1b841fa08f2dd11cf7542c5fa4f4ae365b0cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "98bdec0773fa7d43fff2ce47c4d989d62a6d38efd3d4013b147e286ff3dd88c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a575e5b70146f7fd4e2d13518f105428f59cbd6298f272d4aa9bcfca8944fe05"
  end

  depends_on "cmake" => :build
  depends_on "libzip"

  uses_from_macos "libxml2"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"einfo", "-help"

    (testpath/"test_libepub.c").write <<~C
      #include <stdio.h>
      #include "epub_version.h"

      int main() {
          printf("libepub version: %s\\n", LIBEPUB_VERSION_STRING);
          return 0;
      }
    C

    system ENV.cc, "test_libepub.c", "-I#{include}", "-L#{lib}", "-lepub", "-o", "test_libepub"
    system "./test_libepub"
  end
end
