class Handbrake < Formula
  desc "Open-source video transcoder available for Linux, Mac, and Windows"
  homepage "https://handbrake.fr/"
  url "https://ghproxy.com/github.com/HandBrake/HandBrake/releases/download/1.5.1/HandBrake-1.5.1-source.tar.bz2"
  sha256 "3999fe06d5309c819799a73a968a8ec3840e7840c2b64af8f5cdb7fd8c9430f0"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/HandBrake/HandBrake.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa8e854fe56f002bf523b1e325d12e5019855c568e3a7de2acb29ba52b32d2ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4fa42fc0b58463e6cd070c33b8b3bb244e7c6410e73dbe0e5ebec7f0bbe1bcd7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "29d00fbf281c0a89cddac44850a91cf4b8b5c38e5d60dca8d814c4cba84f251f"
    sha256 cellar: :any_skip_relocation, ventura:        "023e9574369dbd22713401cb6321fa63750210042a928d53272ad355bff32742"
    sha256 cellar: :any_skip_relocation, monterey:       "c522892f41010d47ebd987b763ee064875b2cd12731df17145bc148b75b7651a"
    sha256 cellar: :any_skip_relocation, big_sur:        "be259af1ca277a94651a9eb34f6cd9b17c0e7ecaa61d8d4173f4472cd29e6181"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb626a6155639c58074f5fe87eaacaeb18357908d1c3ad255bc30687d8b5950f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "meson" => :build
  depends_on "nasm" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on xcode: ["10.3", :build]
  depends_on "yasm" => :build

  uses_from_macos "m4" => :build
  uses_from_macos "bzip2"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "jansson"
    depends_on "jpeg-turbo"
    depends_on "lame"
    depends_on "libass"
    depends_on "libvorbis"
    depends_on "libvpx"
    depends_on "numactl"
    depends_on "opus"
    depends_on "speex"
    depends_on "theora"
    depends_on "x264"
    depends_on "xz"
  end

  def install
    inreplace "contrib/ffmpeg/module.defs", "$(FFMPEG.GCC.gcc)", "cc"

    ENV.append "CFLAGS", "-I#{Formula["libxml2"].opt_include}/libxml2" if OS.linux?

    system "./configure", "--prefix=#{prefix}",
                          "--disable-xcode",
                          "--disable-gtk"
    system "make", "-C", "build"
    system "make", "-C", "build", "install"
  end

  test do
    system bin/"HandBrakeCLI", "--help"
  end
end
