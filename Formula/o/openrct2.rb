class Openrct2 < Formula
  desc "Open source re-implementation of RollerCoaster Tycoon 2"
  homepage "https://openrct2.io/"
  url "https://github.com/OpenRCT2/OpenRCT2.git",
      tag:      "v0.4.23",
      revision: "b8d73b523c906993a593a2c2b80d661dbe3da5ee"
  license "GPL-3.0-only"
  revision 1
  head "https://github.com/OpenRCT2/OpenRCT2.git", branch: "develop"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "cdd04cef69d9c4c56e75eee791d51295d5142461250934e72dc3f56accde2d68"
    sha256 cellar: :any, arm64_sonoma:  "3530881c112f7c8a880f1f5f3c778f3c64aa9ee90eba7c28fb026398f2780e84"
    sha256 cellar: :any, sonoma:        "9a7226b35e2187a64bece91a53172036c45b35610ae3fb380a1ad98cf076f8a3"
    sha256               arm64_linux:   "581606d8d9ecc464e2a18d641560ed4f363301335ec40b536662cc6551ebbdac"
    sha256               x86_64_linux:  "4ca2181aa36f3b62c973196364f9989e4de09c57b3ae6d0fae6ad4f7fa26468b"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "pkgconf" => :build

  depends_on "duktape"
  depends_on "flac"
  depends_on "freetype"
  depends_on "icu4c@77"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "libzip"
  depends_on macos: :sonoma # Needs C++20 features not in Ventura
  depends_on "openssl@3"
  depends_on "sdl2"
  depends_on "speexdsp"

  uses_from_macos "zlib"

  on_linux do
    depends_on "curl"
    depends_on "fontconfig"
    depends_on "mesa"
  end

  resource "title-sequences" do
    url "https://mirror.ghproxy.com/https://github.com/OpenRCT2/title-sequences/releases/download/v0.4.14/title-sequences.zip"
    sha256 "140df714e806fed411cc49763e7f16b0fcf2a487a57001d1e50fce8f9148a9f3"
  end

  resource "objects" do
    url "https://mirror.ghproxy.com/https://github.com/OpenRCT2/objects/releases/download/v1.7.0/objects.zip"
    sha256 "c6fdbcb85816fac7cd870cad63aa067376b6bca579991400e8941c0e2b78bbd2"
  end

  resource "openmusic" do
    url "https://mirror.ghproxy.com/https://github.com/OpenRCT2/OpenMusic/releases/download/v1.6/openmusic.zip"
    sha256 "f097d3a4ccd39f7546f97db3ecb1b8be73648f53b7a7595b86cccbdc1a7557e4"
  end

  resource "opensound" do
    url "https://mirror.ghproxy.com/https://github.com/OpenRCT2/OpenSoundEffects/releases/download/v1.0.5/opensound.zip"
    sha256 "a952148be164c128e4fd3aea96822e5f051edd9a0b1f2c84de7f7628ce3b2e18"
  end

  def install
    # Avoid letting CMake download things during the build process.
    (buildpath/"data/sequence").install resource("title-sequences")
    (buildpath/"data/object").install resource("objects")
    resource("openmusic").stage do
      (buildpath/"data/assetpack").install Dir["assetpack/*"]
      (buildpath/"data/object/official").install "object/official/music"
    end
    resource("opensound").stage do
      (buildpath/"data/assetpack").install Dir["assetpack/*"]
      (buildpath/"data/object/official").install "object/official/audio"
    end

    args = %w[
      -DWITH_TESTS=OFF
      -DDOWNLOAD_TITLE_SEQUENCES=OFF
      -DDOWNLOAD_OBJECTS=OFF
      -DDOWNLOAD_OPENMSX=OFF
      -DDOWNLOAD_OPENSFX=OFF
      -DMACOS_USE_DEPENDENCIES=OFF
      -DDISABLE_DISCORD_RPC=ON
    ]
    args << "-DCMAKE_OSX_DEPLOYMENT_TARGET=#{MacOS.version}" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # By default, the macOS build only looks for data in app bundle Resources.
    libexec.install bin/"openrct2"
    (bin/"openrct2").write_env_script "#{libexec}/openrct2", "--openrct2-data-path=#{pkgshare}", {}
  end

  test do
    assert_match "OpenRCT2, v#{version}", shell_output("#{bin}/openrct2 -v")
  end
end
