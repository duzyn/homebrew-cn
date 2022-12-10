class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.3.237.tar.gz"
  sha256 "3f0d9a01a7859efbf312f34140259fc90aa0ba04f635e98f8f36321de4bd509b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2b12b86062b2a3b16362dc782387580a8e10f22688e1bb77c6078a845857c72d"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <vulkan/vulkan_core.h>

      int main() {
        printf("vulkan version %d", VK_VERSION_1_0);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-o", "test"
    system "./test"
  end
end
