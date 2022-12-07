class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://graphviz.org/"
  url "https://gitlab.com/graphviz/graphviz.git",
      tag:      "7.0.4",
      revision: "274d174ce715e31af5bfe6495a2f32fd6cd658b2"
  license "EPL-1.0"
  version_scheme 1
  head "https://gitlab.com/graphviz/graphviz.git", branch: "main"

  bottle do
    sha256 arm64_ventura:  "134cae0258005d17fd091d1a19af410c13a60f9072f38e131612a30d274c2ed2"
    sha256 arm64_monterey: "c7bb13280f9670bf22f780811dcfe6fcdae6b9e576eb10563e7500af4d9c545d"
    sha256 arm64_big_sur:  "3fbd149202a485fc044f15f6cbf89d6f6fa7b075f1bcd007efa166cf93e62c43"
    sha256 ventura:        "700517284960678742e6bb7d109d400f508e75379aaaa7c49c16bf7abb7bfac8"
    sha256 monterey:       "85e44528bfe4c8aa88f72dfae7382e3a1109fff85099316870537d4ec2cf2805"
    sha256 big_sur:        "10110f17dc07915290a29e9b9bf05f1c242c4da4ce221a7a0cb7c235fed3a880"
    sha256 x86_64_linux:   "b550a796849d925da68c978741af061f0cf8c798dcca601ab5e48dd4be268cbb"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "gd"
  depends_on "gts"
  depends_on "libpng"
  depends_on "librsvg"
  depends_on "libtool"
  depends_on "pango"

  uses_from_macos "flex" => :build
  uses_from_macos "python" => :build

  on_linux do
    depends_on "byacc" => :build
    depends_on "ghostscript" => :build
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-php
      --disable-swig
      --disable-tcl
      --with-quartz
      --without-freetype2
      --without-gdk
      --without-gdk-pixbuf
      --without-gtk
      --without-poppler
      --without-qt
      --without-x
      --with-gts
    ]

    system "./autogen.sh"
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"sample.dot").write <<~EOS
      digraph G {
        a -> b
      }
    EOS

    system "#{bin}/dot", "-Tpdf", "-o", "sample.pdf", "sample.dot"
  end
end
