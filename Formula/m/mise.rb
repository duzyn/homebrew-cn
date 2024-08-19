class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://mirror.ghproxy.com/https://github.com/jdx/mise/archive/refs/tags/v2024.8.9.tar.gz"
  sha256 "6566437dac9630d89d5401c0c2b87ee54b7cf7fc9f83d89f01a8ed292b8bc3fb"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7a6821a0f92b2afcc0341d2844710feac6cf9f2cfa14673ce82b3478cbf59e53"
    sha256 cellar: :any,                 arm64_ventura:  "395c0b8ea3be55e7bcce60672acac969cd449847d2e49c66b1ccddc4171e8b7e"
    sha256 cellar: :any,                 arm64_monterey: "fa5625b717c55aab2b353a42a41e42adb1a547d7e2658ae792727d5036aa8bff"
    sha256 cellar: :any,                 sonoma:         "faee057b282d2e6d1cdbcf753c1ad504a3e7d468603881729995efd623c178a9"
    sha256 cellar: :any,                 ventura:        "c302fe9a277e507be1c59a1f6b71e694b4f6d7be0db10a9e270c87bafdecbcb2"
    sha256 cellar: :any,                 monterey:       "f54b4dec3ee07e6d0314131e969ffbb31e8f8d7d01f75e1b996261a91bba64c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af59c9db6eed40defa77217311e238e72f4f9dee5988c2fc3c82e3c9ea0ed449"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  depends_on "libgit2"
  depends_on "openssl@3"

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
