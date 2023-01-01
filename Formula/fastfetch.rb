class Fastfetch < Formula
  desc "Like neofetch, but much faster because written in C"
  homepage "https://github.com/LinusDierheimer/fastfetch"
  url "https://github.com/LinusDierheimer/fastfetch/archive/refs/tags/1.8.1.tar.gz"
  sha256 "5db8ef1b4eba470b55c905ab07e2188bb2e3b4bac7aa868284e0da58c3a36926"
  license "MIT"
  head "https://github.com/LinusDierheimer/fastfetch.git", branch: "dev"

  bottle do
    sha256 arm64_ventura:  "93efe82a5108c224a1df5f7d8ab5e13854964e842a5ac8ba8e6471e769daa16b"
    sha256 arm64_monterey: "bd9f2c6a9d6405346224a4b8bf0dd90dcdbe8c8f65a0af695082bd5ae0082444"
    sha256 arm64_big_sur:  "eb7b3ab51e7c73dd5e93dca48d583e1e581f22136e7808a25fb82cc77525adc6"
    sha256 ventura:        "7ef31427161916336b3d5ac9cdcb24b9db4ca7ee1678ec4048e9fd50b3896e36"
    sha256 monterey:       "1038ff3a7331d0430f642e220075b86c8b996751711f30571db3789e5fbb934d"
    sha256 big_sur:        "bae0cd2c2afd7f3298b8aae4b336166248fed3d02974afb59395b756f54cf303"
    sha256 x86_64_linux:   "1c387714e04fe88523f458697bbf5a79b9a7c7e61d471b735955b66c0992b46d"
  end

  depends_on "chafa" => :build
  depends_on "cmake" => :build
  depends_on "glib" => :build
  depends_on "imagemagick" => :build
  depends_on "pkg-config" => :build
  depends_on "vulkan-loader" => :build

  uses_from_macos "zlib" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "fastfetch", shell_output("#{bin}/fastfetch --version")
    assert_match "OS", shell_output("#{bin}/fastfetch --structure OS --logo none --hide-cursor false")
  end
end
