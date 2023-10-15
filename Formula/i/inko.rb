class Inko < Formula
  desc "Safe and concurrent object-oriented programming language"
  homepage "https://inko-lang.org/"
  url "https://releases.inko-lang.org/0.13.0.tar.gz"
  sha256 "1d63a1ac50abf2578ce69b0207f336d688dc9f745dcbb05c4090469cf824570e"
  license "MPL-2.0"
  head "https://github.com/inko-lang/inko.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8e857ff184919bf20a8dbf4f8671c6734d1ad5379b4fe803b01499684cffa4f8"
    sha256 cellar: :any,                 arm64_monterey: "f845360b7558ffbfcf9ec175d5071cb3cffea531d139b8d925d5d90dc1a46db8"
    sha256 cellar: :any,                 ventura:        "ef6fa1a873d3cf742145eda4fc45004b6a56fa323a25a9d93946f198ebdaab57"
    sha256 cellar: :any,                 monterey:       "042dbc0689157a3d93e7381b66c70e17e569a3f57bf377e65822ead73301f854"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57e9e473be96f46c6f6f9d8a453479d14afbc1cc93a91329aff1ba7fbbd999ec"
  end

  depends_on "coreutils" => :build
  depends_on "llvm@15" => :build
  depends_on "rust" => :build
  depends_on "zstd"

  uses_from_macos "libffi", since: :catalina
  uses_from_macos "ruby", since: :sierra

  def install
    ENV.prepend_path "PATH", Formula["coreutils"].opt_libexec/"gnubin"
    system "make", "build", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"hello.inko").write <<~EOS
      import std.stdio.STDOUT

      class async Main {
        fn async main {
          STDOUT.new.print('Hello, world!')
        }
      }
    EOS
    assert_equal "Hello, world!\n", shell_output("#{bin}/inko run hello.inko")
  end
end
