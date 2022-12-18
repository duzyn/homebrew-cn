class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https://github.com/microsoft/vcpkg"
  url "https://github.com/microsoft/vcpkg-tool/archive/2022-12-14.tar.gz"
  version "2022.12.14"
  sha256 "c7be51b6914e8b6f649c2dd10d855f090a9170914f4c97cbf5f2208a5dc6946c"
  license "MIT"
  head "https://github.com/microsoft/vcpkg-tool.git", branch: "main"

  # The source repository has pre-release tags with the same
  # format as the stable tags.
  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d{4}(?:[._-]\d{2}){2})["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "183f95ededfc0f28d28dc32ab88d6cdbae02c5c25234cfb0d566eeb76faec098"
    sha256 cellar: :any,                 arm64_monterey: "d2a0fc1bc6e6b780c3f5ddcba00c7c082b021fa4283c0bc828daced76b5c5d99"
    sha256 cellar: :any,                 arm64_big_sur:  "be986ae906ffd0665cf641f2f26f49a1a24ae05b36e79284414deed1ab0a0c0e"
    sha256 cellar: :any,                 ventura:        "6dc812cd951900b6ee1f42ca0faf11287ef3b62f2963ca1fa348dfc754580851"
    sha256 cellar: :any,                 monterey:       "d45f5820baa8d79041ce46305d870debd9e244b0a59596b80dbe36dd1717372e"
    sha256 cellar: :any,                 big_sur:        "47df9408518c2f524ab6f4f36244bc5be7832430f1bb2cd5ad1437eba084b8f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5e6a3f49d09d752f074bc7506640a9609c8883e4d0185e6fc5f1e05f5104b82"
  end

  depends_on "cmake" => :build
  depends_on "fmt"
  depends_on "ninja" # This will install its own copy at runtime if one isn't found.

  fails_with gcc: "5"

  def install
    # Improve error message when user fails to set `VCPKG_ROOT`.
    inreplace ["include/vcpkg/base/messages.h", "locales/messages.json"],
              "If you are trying to use a copy of vcpkg that you've built, y", "Y"

    system "cmake", "-S", ".", "-B", "build",
                    "-DVCPKG_DEVELOPMENT_WARNINGS=OFF",
                    "-DVCPKG_BASE_VERSION=#{version.to_s.tr(".", "-")}",
                    "-DVCPKG_VERSION=#{version}",
                    "-DVCPKG_DEPENDENCY_EXTERNAL_FMT=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  # This is specific to the way we install only the `vcpkg` tool.
  def caveats
    <<~EOS
      This formula provides only the `vcpkg` executable. To use vcpkg:
        git clone https://github.com/microsoft/vcpkg "$HOME/vcpkg"
        export VCPKG_ROOT="$HOME/vcpkg"
    EOS
  end

  test do
    # DO NOT CHANGE. If the test breaks then the `inreplace` needs fixing.
    message = "error: Could not detect vcpkg-root. You must define the VCPKG_ROOT environment variable"
    assert_match message, shell_output("#{bin}/vcpkg search sqlite", 1)
  end
end
