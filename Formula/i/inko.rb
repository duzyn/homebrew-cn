class Inko < Formula
  desc "Safe and concurrent object-oriented programming language"
  homepage "https://inko-lang.org/"
  url "https://releases.inko-lang.org/0.18.1.tar.gz"
  sha256 "498d7062ab2689850f56f5a85f5331115a8d1bee147e87c0fdfe97894bc94d80"
  license "MPL-2.0"
  head "https://github.com/inko-lang/inko.git", branch: "main"

  # The upstream website doesn't provide easily accessible version information
  # or link to release tarballs, so we check the release manifest file that
  # the Inko version manager (`ivm`) uses.
  livecheck do
    url "https://releases.inko-lang.org/manifest.txt"
    regex(/^v?(\d+(?:\.\d+)+)$/im)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "49f0d54da76d47c9320f012c06dc3a0911af6ec1e89cf18b12b5c1c0b3c3533f"
    sha256 cellar: :any,                 arm64_sonoma:  "cc1bfc95119a8a67c1a539f61e0d516829d9ff2e873d6e3e7ae84cf1f1609ea9"
    sha256 cellar: :any,                 arm64_ventura: "669cda920c7891a1cc1a0615dd512d86fe5c2d09d6100e5fcc4f32073f7a76c8"
    sha256 cellar: :any,                 sonoma:        "dc11a3da6b121b21114999e46e39602b6144c33c569362a07a49dddf600b2033"
    sha256 cellar: :any,                 ventura:       "b02d0be8718895494cead50e1987f7de6c54ae57843cdc5cc41efb19abec2ad5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a464bbf5537cbf94b716031ed226554911d45581444207f3cc19b8f8c185dbe"
  end

  depends_on "coreutils" => :build
  depends_on "rust" => :build
  depends_on "llvm@17" # see https://github.com/inko-lang/inko/blob/4738b81dbec1f50dadeec3608dde855583f80dda/ci/mac.sh#L5
  depends_on "zstd"

  uses_from_macos "libffi", since: :catalina
  uses_from_macos "ncurses"
  uses_from_macos "ruby", since: :sierra
  uses_from_macos "zlib"

  on_macos do
    depends_on "z3"
  end

  def install
    ENV.prepend_path "PATH", Formula["coreutils"].opt_libexec/"gnubin"
    system "make", "build", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"hello.inko").write <<~EOS
      import std.stdio (Stdout)

      class async Main {
        fn async main {
          Stdout.new.print('Hello, world!')
        }
      }
    EOS
    assert_equal "Hello, world!\n", shell_output("#{bin}/inko run hello.inko")
  end
end
