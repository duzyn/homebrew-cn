class GameMusicEmu < Formula
  desc "Videogame music file emulator collection"
  homepage "https://github.com/libgme/game-music-emu"
  url "https://mirror.ghproxy.com/https://github.com/libgme/game-music-emu/archive/refs/tags/0.6.3.tar.gz"
  sha256 "4c5a7614acaea44e5cb1423817d2889deb82674ddbc4e3e1291614304b86fca0"
  license one_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  revision 2
  head "https://github.com/libgme/game-music-emu.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "5ef428a2f2cfa529a20d3a11be7e92ac70f0a7c88cfa76c57d1fb9be14ea7ec2"
    sha256 cellar: :any,                 arm64_sonoma:   "70bb1a2c61c5cfe9db5cea20d195b0a667584a462bd034eef4063b03948c883d"
    sha256 cellar: :any,                 arm64_ventura:  "c33d21ce67a78b16cfe0e2e68372c62df99bec7d7c73ee20e9acece876ae2e0b"
    sha256 cellar: :any,                 arm64_monterey: "1346614b5a9561f7eaace297b5493eeb99ec4c3e561acc65669ca6dbb0cd6793"
    sha256 cellar: :any,                 arm64_big_sur:  "e83fbee26086cc93f7d2eed7d3b93f00a0a0c9eb9d59abf3aba91216fe89d3d8"
    sha256 cellar: :any,                 sonoma:         "455b9e0b0d15d199a355fa22f242f4887bb67557f145c7ddc17ba7f0659bc7a2"
    sha256 cellar: :any,                 ventura:        "7b686c42bec0fd89a976842ca616e41b8c40883d461faf49da21409e96585cb6"
    sha256 cellar: :any,                 monterey:       "7b1e5a6934c8ff16fff726c1963e465abd11458f5773f26b38ce8771da3289a1"
    sha256 cellar: :any,                 big_sur:        "a0abdc4c5ae05ea22ad3627a1a717ed8a1a137065188b995858c0f301dfda640"
    sha256 cellar: :any,                 catalina:       "ee658e16c3d9d0061b0b930ca387a1cb2fa6b6b50d23c9f6f4ae7799ddb6f46d"
    sha256 cellar: :any,                 mojave:         "754ab0c8bc0a6de76adcb56a59913c930196e8e44154958081c093fb7763edad"
    sha256 cellar: :any,                 high_sierra:    "596497823bb1ebb30f20fa01c8656bb15544c12fad5d67c4de165f9ef3122e68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08b3b37367e9fada0881a14a96a8970eecb79426a378d02dc7ed8881923096f3"
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DENABLE_UBSAN=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <gme/gme.h>
      int main(void)
      {
        Music_Emu* emu;
        gme_err_t error;

        error = gme_open_data((void*)0, 0, &emu, 44100);

        if (error == gme_wrong_file_type) {
          return 0;
        } else {
          return -1;
        }
      }
    C

    if OS.mac?
      ubsan_libdir = Dir["#{MacOS::CLT::PKG_PATH}/usr/lib/clang/*/lib/darwin"].first
      rpath = "-Wl,-rpath,#{ubsan_libdir}"
    end

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", *(rpath if OS.mac?),
                   "-lgme", "-o", "test", *ENV.cflags.to_s.split
    system "./test"
  end
end
