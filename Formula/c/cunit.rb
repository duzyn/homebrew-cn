class Cunit < Formula
  desc "Lightweight unit testing framework for C"
  homepage "https://cunit.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/cunit/CUnit/2.1-3/CUnit-2.1-3.tar.bz2?use_mirror=jaist"
  sha256 "f5b29137f845bb08b77ec60584fdb728b4e58f1023e6f249a464efa49a40f214"
  license "LGPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "ed2227559e5ab1d8239ee28d11b8728832ac2301041631b31702a12be8f0d3fe"
    sha256 cellar: :any,                 arm64_sonoma:   "92297087d6f77632f4db7fb8c436ba6f70c9da28fdc11e56cb975a86ea27cc90"
    sha256 cellar: :any,                 arm64_ventura:  "346705eb07dd79665dba7f918a7c33af02a2dbacb975d5c99c0d7f45afb1ecaa"
    sha256 cellar: :any,                 arm64_monterey: "fd5bba3a249137e905676e8a80118c9aaaa8f2795ab0d7fab44407d8fe75e07f"
    sha256 cellar: :any,                 arm64_big_sur:  "699850740de719430e01f95dcd1391d00d67f3b8e4a29201bdfc73cab9d2d04a"
    sha256 cellar: :any,                 sonoma:         "2b467d2ee01bc6ac502daa3dda52f38483699972d8171e49b85083d6c2c7812e"
    sha256 cellar: :any,                 ventura:        "1091cec262b92bf2b8ce1b1e579afd1841ab3edbc9151fefb733a4707cd69b6c"
    sha256 cellar: :any,                 monterey:       "ffad854086ea13dde40c23736591da90c3d66ef95677e14d90f2c49891f1302a"
    sha256 cellar: :any,                 big_sur:        "2d5e3e62c0d0cd5cbf119d93249ca2ab671bebf53c77947d5c59daaad55aefed"
    sha256 cellar: :any,                 catalina:       "5a03cc656131d1bcde14ec200be947c5b3caee6f5138e426b2b27b0286c59ee7"
    sha256 cellar: :any,                 mojave:         "561baccf9e285cd65021b70342d1ba37b456a2f35c0324dfd2a65ea427641d27"
    sha256 cellar: :any,                 high_sierra:    "23fdc88eeb1c4cf8d58e281e046f2e45a56860c0091e5c76f757f01679d143d2"
    sha256 cellar: :any,                 sierra:         "dc987998ebcfc175c9c9e70c6b83db4197bd5b79d383235b85ee8a30835785df"
    sha256 cellar: :any,                 el_capitan:     "0b92535641c86f38bf7a3a1b08a07aa6523e4c0135792dd92829e00579a5e3a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "3ccc99f7c608efe03b30e0e008a0cfcac24582f6189157a155e1cb6fe7901ed4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0cf6507f41f3b367c36329688073277d4db50e61b048e39360f1e58cf2482e6"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    inreplace "bootstrap", "libtoolize", "glibtoolize"
    system "sh", "bootstrap", prefix
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <string.h>
      #include "CUnit/Basic.h"

      int noop(void) { return 0; }

      void test42(void) { CU_ASSERT(42 == 42); }

      int main(void)
      {
         CU_pSuite pSuite = NULL;
         if (CUE_SUCCESS != CU_initialize_registry())
            return CU_get_error();
         pSuite = CU_add_suite("Suite_1", noop, noop);
         if (NULL == pSuite) {
            CU_cleanup_registry();
            return CU_get_error();
         }
         if (NULL == CU_add_test(pSuite, "test of 42", test42)) {
            CU_cleanup_registry();
            return CU_get_error();
         }
         CU_basic_set_mode(CU_BRM_VERBOSE);
         CU_basic_run_tests();
         CU_cleanup_registry();
         return CU_get_error();
      }
    C

    system ENV.cc, "test.c", "-L#{lib}", "-lcunit", "-o", "test"
    assert_match "test of 42 ...passed", shell_output("./test")
  end
end
