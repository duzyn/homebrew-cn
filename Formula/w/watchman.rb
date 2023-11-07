class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://ghproxy.com/https://github.com/facebook/watchman/archive/refs/tags/v2023.10.30.00.tar.gz"
  sha256 "57ff2a308e27c245e3e4795a81b446254b3bc699cb88786123ef19501712ba5f"
  license "MIT"
  revision 1
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f6fa608cc62ebc86f1b06b572109828d3c9741a24695cdc5c2ce70e0339ac44f"
    sha256 cellar: :any,                 arm64_ventura:  "3d8a3febd98e282ab66b2fc4d0b7f1287681e5431097f87ce3da0659a22cad86"
    sha256 cellar: :any,                 arm64_monterey: "cb2e00e66e06f5148eebcb745ca64696a91112ca6da84d5e22010ae92a52a9f3"
    sha256 cellar: :any,                 sonoma:         "e6be2d1a6e0d3c2683efb2c762b09c85393e74d50e8f66b9425b18efb4603aca"
    sha256 cellar: :any,                 ventura:        "f604a7c93855e1f8b4c59dc676a92565db75e01bc7b8056e4946b3c542850f50"
    sha256 cellar: :any,                 monterey:       "a91e15d55a9aa60bee062e820eb2fa3a5b142ba371264e92280ca8130e0d2b7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfe4c83a5cf029a17c4ec3a95dd49a4a6932edaa795144060ebfa51dcf967705"
  end

  # https://github.com/facebook/watchman/issues/963
  pour_bottle? only_if: :default_prefix

  depends_on "cmake" => :build
  depends_on "cpptoml" => :build
  depends_on "fbthrift" => :build
  depends_on "googletest" => :build
  depends_on "mvfst" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "boost"
  depends_on "edencommon"
  depends_on "fb303"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "libsodium"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "python@3.11"

  fails_with gcc: "5"

  def install
    # Fix "Process terminated due to timeout" by allowing a longer timeout.
    inreplace "CMakeLists.txt",
              /gtest_discover_tests\((.*)\)/,
              "gtest_discover_tests(\\1 DISCOVERY_TIMEOUT 60)"

    # NOTE: Setting `BUILD_SHARED_LIBS=ON` will generate DSOs for Eden libraries.
    #       These libraries are not part of any install targets and have the wrong
    #       RPATHs configured, so will need to be installed and relocated manually
    #       if they are built as shared libraries. They're not used by any other
    #       formulae, so let's link them statically instead. This is done by default.
    system "cmake", "-S", ".", "-B", "build",
                    "-DENABLE_EDEN_SUPPORT=ON",
                    "-DPython3_EXECUTABLE=#{which("python3.11")}",
                    "-DWATCHMAN_VERSION_OVERRIDE=#{version}",
                    "-DWATCHMAN_BUILDINFO_OVERRIDE=#{tap.user}",
                    "-DWATCHMAN_STATE_DIR=#{var}/run/watchman",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    path = Pathname.new(File.join(prefix, HOMEBREW_PREFIX))
    bin.install (path/"bin").children
    lib.install (path/"lib").children
    path.rmtree
  end

  def post_install
    (var/"run/watchman").mkpath
    chmod 042777, var/"run/watchman"
  end

  test do
    assert_equal(version.to_s, shell_output("#{bin}/watchman -v").chomp)
  end
end
