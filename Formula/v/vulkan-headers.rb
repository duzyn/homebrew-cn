class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://mirror.ghproxy.com/https://github.com/KhronosGroup/Vulkan-Headers/archive/refs/tags/v1.4.315.tar.gz"
  sha256 "77e3a78db853f8b9c5bc3ddef04e637bef9744e01d6a8c90ebe0ddcd916c0c50"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Headers.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "139b1706725982bdf168904c597ee0549a1303d47e70acb0553d4e3ba8999c90"
  end

  depends_on "cmake" => :build

  def install
    # Ensure bottles are uniform.
    inreplace "include/vulkan/vulkan.hpp" do |s|
      s.gsub! "/usr/local", HOMEBREW_PREFIX
    end

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <vulkan/vulkan_core.h>

      int main() {
        printf("vulkan version %d", VK_VERSION_1_0);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test"
    system "./test"
  end
end
