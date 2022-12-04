class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v1.3.236.tar.gz"
  sha256 "c18434976d6e67c3c1d5cfdfa630046e698402d1f666ff5094de1fcd3a012b0d"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "d22789614d65cd8d064b0ad2b5a220761f01c2a0580a4440532c46b0cf98a9b8"
    sha256 arm64_monterey: "7e5b2dee188180b1477ef34e68866cad43c740c5c6ac839ef21dd554b6b5ceaf"
    sha256 arm64_big_sur:  "c92b596b247066d43d1de8a29d235e2b11e29ce476788e60846dd03a27564446"
    sha256 ventura:        "ce83d6d4012af842a37fd9292c6e0eb0742cc57246cf3b0c805bff64057432d8"
    sha256 monterey:       "ba2e5e95499b3c7cbf78ac06159d2d80ccc2706aeaf37d7df7c3033eef38ef47"
    sha256 big_sur:        "baf966150eba5820dadb3e0ad47d4f8874ab045d06701d582f31bf3a2bdaa040"
    sha256 x86_64_linux:   "bcc2c70c720b230b2848b673089fc50faaa28c8b63f1be2aea71ccab86f99527"
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
