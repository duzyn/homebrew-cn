class Uv < Formula
  desc "Extremely fast Python package installer and resolver, written in Rust"
  homepage "https://github.com/astral-sh/uv"
  url "https://mirror.ghproxy.com/https://github.com/astral-sh/uv/archive/refs/tags/0.1.6.tar.gz"
  sha256 "432a2890a0c8d3273a3d5d35c4370f561c10cf513061952886b00113a3830fd6"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/astral-sh/uv.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ac33af7995fc3039ff5550a974f83898dd8a47c45bbaede57ae8c05adb91e7ec"
    sha256 cellar: :any,                 arm64_ventura:  "f45d7152c8a3e2f932605651197c61dc97c13feb2d0177ae9ac1d3cb00d8f47d"
    sha256 cellar: :any,                 arm64_monterey: "976fe0fa13acaa7b912fff280c04f12045a454140390d5d44ff5d7c81fe6d68f"
    sha256 cellar: :any,                 sonoma:         "993d30e0e47519033e366374e2f708efc57e37dedb729097db5e68b5d3c7b8e9"
    sha256 cellar: :any,                 ventura:        "788acae63485df5fa917b585b6c85966e59e18ccc60fa8b15f2f224689b8d35b"
    sha256 cellar: :any,                 monterey:       "ff445601e2fb573b13b3b84bde669d8a8c00e75f203101321a85c16bac197ead"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51661e6141a2f950811321c8e39bae658222f9e1a61a89fa671bdad8895a16a0"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@3"

  uses_from_macos "python" => :test

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/uv")
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    (testpath/"requirements.in").write <<~EOS
      requests
    EOS

    compiled = shell_output("#{bin}/uv pip compile -q requirements.in")
    assert_match "This file was autogenerated by uv", compiled
    assert_match "# via requests", compiled

    [
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin/"uv", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
