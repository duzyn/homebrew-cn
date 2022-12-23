class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p6.0.20221218.0.tar.gz"
  version "p6.0.20221218.0"
  sha256 "790bfabae5d5694a902a39dbc9be63002f7827ac479a6417d8b049da6c432f0f"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a6221c756552a4b2f41f5f36abe55a162df0ad98e4485fc4965086ea4e3d9b08"
    sha256 cellar: :any,                 arm64_monterey: "7aa08644ac78ea79eb14cb00caf742da309cdc888855b5bd9fe329cc9e21af2d"
    sha256 cellar: :any,                 arm64_big_sur:  "4652da4769b644c8f2035b18461eb345aa5131404a0ac17becf4bd2448afabcf"
    sha256 cellar: :any,                 ventura:        "52fe7f0ca16bf7c4819150588b5a41da6af0e7bef32324d0fd10755409b224a5"
    sha256 cellar: :any,                 monterey:       "6a48f719112af943751c13f99bb733b153795b2ba89b854fad0d48c46322630f"
    sha256 cellar: :any,                 big_sur:        "5bb9aab9ba81b34b1e9354038dc9f8b59e89f6a3163d8c635092a103a6dcb5f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "022fecc2938149eb1fa7577724ccb36bcc3318cf575168897ec8c73fb1fa8e44"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docutils" => :build
  depends_on "pkg-config" => :build
  depends_on "jansson"
  depends_on "libyaml"

  uses_from_macos "libxml2"

  conflicts_with "ctags", because: "this formula installs the same executable as the ctags formula"

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <stdlib.h>

      void func()
      {
        printf("Hello World!");
      }

      int main()
      {
        func();
        return 0;
      }
    EOS
    system bin/"ctags", "-R", "."
    assert_match(/func.*test\.c/, File.read("tags"))
  end
end
