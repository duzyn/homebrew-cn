class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v1.3.237.tar.gz"
  sha256 "03cfe1cb3dc5623304f64a2d0e8714dd8b51702da71365dacb9fbdc1f9ac138e"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "0964133f74636ed195c79175f7c7b9d4e80e42702a839c623011d5c121d22d04"
    sha256 arm64_monterey: "988c076764839fd31631550dad41507c6db97d3a24cd164fe1104d2fc9888dcd"
    sha256 arm64_big_sur:  "9c80020b17996be96659d2a2233491b2ff6f7d25ab3fc51fc7813b759835ea0a"
    sha256 ventura:        "73e6a77c5c41551f9dc1a754a6edc30af359bd4d1d74fff182561caba431c886"
    sha256 monterey:       "da2dc29a8f950cf37cef2540165418cb159fd16f2733e650654263364029256b"
    sha256 big_sur:        "f91e6d06f7835703d9609abe5eace5b1b979a201bb6e6a8292ae1340b1794df6"
    sha256 x86_64_linux:   "b340cd660fe79cfc66e1bbfd83cdb70fdd90bc952c63e8d3aaa3c5f101f48675"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "vulkan-headers"

  on_linux do
    depends_on "libxrandr" => :build
    depends_on "libx11"
    depends_on "libxcb"
    depends_on "wayland"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DVULKAN_HEADERS_INSTALL_DIR=#{Formula["vulkan-headers"].opt_prefix}",
                    "-DFALLBACK_DATA_DIRS=#{HOMEBREW_PREFIX}/share:/usr/local/share:/usr/share",
                    "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}",
                    "-DFALLBACK_CONFIG_DIRS=#{etc}/xdg:/etc/xdg",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    inreplace lib/"pkgconfig/vulkan.pc", /^Cflags: .*/, "Cflags: -I#{Formula["vulkan-headers"].opt_include}"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <vulkan/vulkan_core.h>
      int main() {
        uint32_t version;
        vkEnumerateInstanceVersion(&version);
        return (version >= VK_API_VERSION_1_1) ? 0 : 1;
      }
    EOS
    system ENV.cc, "-o", "test", "test.c", "-I#{Formula["vulkan-headers"].opt_include}",
                   "-L#{lib}", "-lvulkan"
    system "./test"
  end
end
