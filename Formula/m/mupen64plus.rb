class Mupen64plus < Formula
  desc "Cross-platform plugin-based N64 emulator"
  homepage "https://www.mupen64plus.org/"
  url "https://mirror.ghproxy.com/https://github.com/mupen64plus/mupen64plus-core/releases/download/2.5/mupen64plus-bundle-src-2.5.tar.gz"
  sha256 "9c75b9d826f2d24666175f723a97369b3a6ee159b307f7cc876bbb4facdbba66"
  license "GPL-2.0-or-later"
  revision 9

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 sonoma:       "c230208074feda97c361199781940d50f7918419802ec903eec833d3ff2c0af0"
    sha256 ventura:      "2c6365b16dbb1c3e70acd5068dfeab479f0742d8c9ae8df40df40af5524b119d"
    sha256 monterey:     "81ce3aecfc6b2f110322459cbdde89176590fe8e445d75ca7136dfec520c7f4d"
    sha256 x86_64_linux: "e4140dea7a57faf9c5f5adcd2a5b8803f7e19ba989c7f375c73d84a2d3459010"
  end

  depends_on "pkg-config" => :build
  depends_on arch: :x86_64
  depends_on "boost"
  depends_on "freetype"
  depends_on "libpng"
  depends_on "sdl2"

  uses_from_macos "zlib"

  on_linux do
    depends_on "mesa"
  end

  resource "rom" do
    url "https://mirror.ghproxy.com/https://github.com/mupen64plus/mupen64plus-rom/raw/76ef14c876ed036284154444c7bdc29d19381acc/m64p_test_rom.v64"
    sha256 "b5fe9d650a67091c97838386f5102ad94c79232240f9c5bcc72334097d76224c"
  end

  def install
    # Work around build failure with `boost` 1.85.0
    # Issue ref: https://github.com/mupen64plus/mupen64plus-video-glide64mk2/issues/128
    wpath_files = %w[
      source/mupen64plus-video-glide64mk2/src/GlideHQ/TxCache.cpp
      source/mupen64plus-video-glide64mk2/src/GlideHQ/TxHiResCache.cpp
      source/mupen64plus-video-glide64mk2/src/GlideHQ/TxHiResCache.h
      source/mupen64plus-video-glide64mk2/src/GlideHQ/TxTexCache.cpp
    ]
    inreplace wpath_files, /\bboost::filesystem::wpath\b/, "boost::filesystem::path"
    inreplace "source/mupen64plus-video-glide64mk2/src/GlideHQ/TxHiResCache.cpp",
              "->path().leaf().", "->path().filename()."

    # Prevent different C++ standard library warning
    if OS.mac?
      inreplace Dir["source/mupen64plus-**/projects/unix/Makefile"],
                /(-mmacosx-version-min)=\d+\.\d+/,
                "\\1=#{MacOS.version}"
    end

    # Fix build with Xcode 9 using upstream commit:
    # https://github.com/mupen64plus/mupen64plus-video-glide64mk2/commit/5ac11270
    # Remove in next version
    inreplace "source/mupen64plus-video-glide64mk2/src/Glide64/3dmath.cpp",
              "__builtin_ia32_storeups", "_mm_storeu_ps"

    if OS.linux?
      ENV.append "CFLAGS", "-fcommon"
      ENV.append "CFLAGS", "-fpie"
    end

    args = ["install", "PREFIX=#{prefix}", "COREDIR=#{lib}/"]
    args << if OS.mac?
      "INSTALL_STRIP_FLAG=-S"
    else
      "USE_GLES=1"
    end

    cd "source/mupen64plus-core/projects/unix" do
      system "make", *args
    end

    cd "source/mupen64plus-audio-sdl/projects/unix" do
      system "make", *args, "NO_SRC=1", "NO_SPEEX=1"
    end

    cd "source/mupen64plus-input-sdl/projects/unix" do
      system "make", *args
    end

    cd "source/mupen64plus-rsp-hle/projects/unix" do
      system "make", *args
    end

    cd "source/mupen64plus-video-glide64mk2/projects/unix" do
      system "make", *args
    end

    cd "source/mupen64plus-video-rice/projects/unix" do
      system "make", *args
    end

    cd "source/mupen64plus-ui-console/projects/unix" do
      system "make", *args, "PIE=1"
    end
  end

  test do
    # Disable test in Linux CI because it hangs because a display is not available.
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    resource("rom").stage do
      system bin/"mupen64plus", "--testshots", "1",
             "m64p_test_rom.v64"
    end
  end
end
