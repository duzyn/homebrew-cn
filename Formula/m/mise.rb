class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://mirror.ghproxy.com/https://github.com/jdx/mise/archive/refs/tags/v2024.10.5.tar.gz"
  sha256 "6a2edff4dd0cc91c2d81741b29b6fa2eebfeae3b6d76eec677d55f439104631d"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "31841c04cb006ce2d147b75eaee4cbf85e7733c80c3d5f7eecbd1bd89c6c1b38"
    sha256 cellar: :any,                 arm64_sonoma:  "ecd05874e2c042bf94e724d55893d84cc29f02fac6907467ac4e4a0e13df68b7"
    sha256 cellar: :any,                 arm64_ventura: "84af367a5d86bdcbce8cb7660c6b978c0ad691089e5e9d1c41100883d1bfc812"
    sha256 cellar: :any,                 sonoma:        "37525626f56b6889d196e6af5d03f7797ea732f98cf3a0147ba41400ee0120df"
    sha256 cellar: :any,                 ventura:       "be115fc20bfe8f1f330bb6cee9267be68b86d0238cad44d85e63f7bcabca5fdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf4efb10438260a627e5992da7a984078f94da38bfe52d343f0ff5d903f2d2ec"
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
    system bin/"mise", "install", "terraform@1.5.7"
    assert_match "1.5.7", shell_output("#{bin}/mise exec terraform@1.5.7 -- terraform -v")

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
