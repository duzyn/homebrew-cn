class Libgosu < Formula
  desc "2D game development library"
  homepage "https://libgosu.org"
  url "https://github.com/gosu/gosu/archive/v1.4.4.tar.gz"
  sha256 "d9df31f365fdbe74c6727d19c91e43cc643e884b317b4f37c625cd6fbd0b2a1e"
  license "MIT"
  head "https://github.com/gosu/gosu.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0902566a746f1e47c0ef4cde5ce17e0a7ae35d45046de3da8fd8e64ddb37336a"
    sha256 cellar: :any,                 arm64_monterey: "a9f9077b8cb8abed67b40c080db2fe3ad15b9b22bf35c991359d4cd79b9c83a6"
    sha256 cellar: :any,                 arm64_big_sur:  "35577bae46c25a270b1f203e9754a0ad0fe84f81fe8a47c227dc747aa32e2dc6"
    sha256 cellar: :any,                 ventura:        "59dc269d9dbff95365dd55d12061fc49a43e02cb12220f8842354fea69681f3e"
    sha256 cellar: :any,                 monterey:       "d6195bed2e82548d1599078bb7078699e309c3985d7bba36aaacf1709d7d72a5"
    sha256 cellar: :any,                 big_sur:        "8eba000174e16aef2bb897e2f5f5b8a8b2570d63503a55e52d902fe82d32b266"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ca4d46f26434a5064f82e091ba85c6798f4293166873b93ea93d30616711be7"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "sdl2"

  on_linux do
    depends_on "fontconfig"
    depends_on "mesa"
    depends_on "mesa-glu"
    depends_on "openal-soft"
  end

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <stdlib.h>
      #include <Gosu/Gosu.hpp>

      class MyWindow : public Gosu::Window
      {
      public:
          MyWindow()
          :   Gosu::Window(640, 480)
          {
              set_caption("Hello World!");
          }

          void update()
          {
              exit(0);
          }
      };

      int main()
      {
          MyWindow window;
          window.show();
      }
    EOS

    system ENV.cxx, "test.cpp", "-o", "test", "-L#{lib}", "-lgosu", "-I#{include}", "-std=c++17"

    # Fails in Linux CI with "Could not initialize SDL Video: No available video device"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "./test"
  end
end
