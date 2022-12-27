class Libplacebo < Formula
  include Language::Python::Virtualenv

  desc "Reusable library for GPU-accelerated image/video processing primitives"
  homepage "https://code.videolan.org/videolan/libplacebo"
  license "LGPL-2.1-or-later"
  head "https://code.videolan.org/videolan/libplacebo.git", branch: "master"

  stable do
    url "https://code.videolan.org/videolan/libplacebo/-/archive/v5.229.1/libplacebo-v5.229.1.tar.bz2"
    sha256 "fef7000bd498921c2f6eb567a60c95fbb3ea39ff0a3d5cc68176eb27b5dd882c"

    resource "glad" do
      url "https://files.pythonhosted.org/packages/e5/5f/a88837847083930e289e1eee93a9376a0a89a2a373d148abe7c804ad6657/glad2-2.0.2.tar.gz"
      sha256 "c2d1c51139a25a36dbadeef08604347d1c8d8cc1623ebed88f7eb45ade56379e"
    end

    resource "jinja" do
      url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
      sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
    end

    resource "markupsafe" do
      url "https://files.pythonhosted.org/packages/1d/97/2288fe498044284f39ab8950703e88abbac2abbdf65524d576157af70556/MarkupSafe-2.1.1.tar.gz"
      sha256 "7f91197cc9e48f989d12e4e6fbc46495c446636dfc81b9ccf50bb0ec74b91d4b"
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_ventura:  "055dbd89e69f58447d39d65cd6fb5e4aa4a2d2578c2280e7e60f12051f76d39c"
    sha256 cellar: :any, arm64_monterey: "ea1e01b89763e27a7219510b03fbe3ed4f17d513de51cea168cf59199abd2545"
    sha256 cellar: :any, arm64_big_sur:  "9e3539489567f5417f49e2b70f38fa3a14be86e8ea6379b2b412069fe98e94e4"
    sha256 cellar: :any, ventura:        "5ae33f34e0ae55c613f4c37040947fd482fc0e1f506593d4199b8227d832579b"
    sha256 cellar: :any, monterey:       "7cbfbfe4985012f6b8753c3c0019a096518b75e28164879d6809ee2f97b706a3"
    sha256 cellar: :any, big_sur:        "08dd1b8a4e5e6f2d56363953f5fb64675610bbf706d2e69b70a4cba6b51addc6"
    sha256               x86_64_linux:   "970be798182521f9d044d5b26b6dfd7a92adc31b93f0686e0d5162ccccb98ce7"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "python@3.11" => :build
  depends_on "vulkan-headers" => :build

  depends_on "ffmpeg"
  depends_on "glslang"
  depends_on "little-cms2"
  depends_on "sdl2"
  depends_on "vulkan-loader"

  def install
    resources.each do |r|
      r.stage(Pathname("3rdparty")/r.name)
    end

    system "meson", "setup", "build",
                    "-Dvulkan-registry=#{Formula["vulkan-headers"].share}/vulkan/registry/vk.xml",
                    *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libplacebo/config.h>
      #include <stdlib.h>
      int main() {
        return (pl_version() != NULL) ? 0 : 1;
      }
    EOS
    system ENV.cc, "-o", "test", "test.c", "-I#{include}",
                   "-L#{lib}", "-lplacebo"
    system "./test"
  end
end
