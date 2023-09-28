class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://ghproxy.com/https://github.com/RoaringBitmap/CRoaring/archive/v2.0.1.tar.gz"
  sha256 "1d1b46523c178a2d2c935ad089c026c8ca8e5c2e18fba350d3dce161e6910c11"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "68bf147971ac1fa342b017e7d2115db508af69acad38e3599c4cf86222c1f0ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4d5ee1ba70e0356cd90e79759bb775209c9520ec6c24596575fad0dc85d8535f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "605db4ff3a26332f58f039a4ab308281ceadbe3fb5678dae8f18acbef6cc5d2d"
    sha256 cellar: :any_skip_relocation, sonoma:         "66c932c24098b8dc8e5e73a5e502583fdebd1e7db35e0a4c27fa3c65688c331e"
    sha256 cellar: :any_skip_relocation, ventura:        "b324cfa9772fbcc4af1fb0de9633e78d0fb83a782511a64a4fa87479b0620a64"
    sha256 cellar: :any_skip_relocation, monterey:       "b972d46b4dbefd52ff9c431be4d2673a94433978318624e299a773beabd99c69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4e2319be56f0c591c4cd54f8178c43d5feeef7f62f42dfbb39ba3dbb55263dd"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DENABLE_ROARING_TESTS=OFF",
                    "-DROARING_BUILD_STATIC=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
