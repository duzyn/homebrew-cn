class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/v0.8.1.tar.gz"
  sha256 "5359f2a051f10e42cea5edc3cb3650fd272e9125e6a0538901cf30619939d4f8"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "33d23f59f9a16ec49698da6d68c0981649baa0e47371449c2a156bc607732abb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9cebbc15f090c345a2a97214653e60f0788e533e3284fd47dd47e54a83b604c2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "33b05512c283b6e9a0177a0accfb01772b0cdd025a2b60cf06fb7aa79fc99bb6"
    sha256 cellar: :any_skip_relocation, ventura:        "95bb6ef6007a7672bf38e69b0f75c7b3b2607864155883eb69f8e768786c4159"
    sha256 cellar: :any_skip_relocation, monterey:       "4972c41fbd7ad22aca9f8b33da00c78fe400acd4d23e999beded6f415056dda3"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab2c4d872c6cee86c6b420c14bf88b9aecadaa4230d64aa0f1c08d5403cc1173"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e72611b52b4b2bf1bea0545ea2dda4de4662df94eba8de8bd478dbd878264ea"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args, "-DENABLE_ROARING_TESTS=OFF"
    system "make", "install"
    system "make", "clean"
    system "cmake", ".", *std_cmake_args, "-DROARING_BUILD_STATIC=ON"
    system "make"
    lib.install "src/libroaring.a"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <roaring/roaring.h>
      int main() {
          roaring_bitmap_t *r1 = roaring_bitmap_create();
          for (uint32_t i = 100; i < 1000; i++) roaring_bitmap_add(r1, i);
          printf("cardinality = %d\\n", (int) roaring_bitmap_get_cardinality(r1));
          roaring_bitmap_free(r1);
          return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lroaring", "-o", "test"
    assert_equal "cardinality = 900\n", shell_output("./test")
  end
end
