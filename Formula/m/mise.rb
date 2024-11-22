class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://mirror.ghproxy.com/https://github.com/jdx/mise/archive/refs/tags/v2024.11.21.tar.gz"
  sha256 "44ca96113ccdf87b14fbc4f64875243c0c611b9063d7c8a99d21d8b8ef1f3794"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d08adb059d37af92d78c0edfadb2183591c14826b91593b23761498adac118ee"
    sha256 cellar: :any,                 arm64_sonoma:  "040cb0b4c56f48167fd3b1c70266e93e3c750ad6aff77681455d68c4d5607d66"
    sha256 cellar: :any,                 arm64_ventura: "f2862965c20cb9ed3f1f38d5da69243f6c68a230d0ad022c8b11a721be20fd7d"
    sha256 cellar: :any,                 sonoma:        "54be0f3fe94cadd0f8f5cda1ce5e182332035814946497022472fbf4223bb78a"
    sha256 cellar: :any,                 ventura:       "fbffb3834f152378d551204969cee24f092b92bb69af59524117a1273fd5a91c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c13eb44454fa3607998975a2c581c26e397e6874d461fd5b875c3fd7fa2a299d"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  depends_on "libgit2"
  depends_on "openssl@3"
  depends_on "usage"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "xz" # for liblzma
  end

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
    man1.install "man/man1/mise.1"
    generate_completions_from_executable(bin/"mise", "completion")
    lib.mkpath
    touch lib/".disable-self-update"
    (share/"fish"/"vendor_conf.d"/"mise-activate.fish").write <<~EOS
      if [ "$MISE_FISH_AUTO_ACTIVATE" != "0" ]
        #{opt_bin}/mise activate fish | source
      end
    EOS
  end

  def caveats
    <<~EOS
      If you are using fish shell, mise will be activated for you automatically.
    EOS
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    system bin/"mise", "settings", "set", "experimental", "true"
    system bin/"mise", "use", "node@22"
    assert_match "22", shell_output("#{bin}/mise exec -- node -v")

    [
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin/"mise", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
