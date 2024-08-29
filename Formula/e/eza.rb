class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https://github.com/eza-community/eza"
  url "https://mirror.ghproxy.com/https://github.com/eza-community/eza/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "a256ecdb9996933300bb54e19a68df61e27385e5df20ba1f780f2e454a7f8e8a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "747a792b1a62ba0ce70f805f93a86d45fc52d0cc6e6e5d9dfe1143edf53ad693"
    sha256 cellar: :any,                 arm64_ventura:  "b1410cd5ca1e9ead722e433b54937c3de13703b451a51909c6719fd37fb9e540"
    sha256 cellar: :any,                 arm64_monterey: "de6a0c30c98ead503d543257f1d0edacf1c02a5b401dc37764420bb0be9ead4e"
    sha256 cellar: :any,                 sonoma:         "84edef64b0339951bb8f85f85b8c3ab99e2488ea05423d18303a6485517d082f"
    sha256 cellar: :any,                 ventura:        "a8add97c23411972a63308abd456442b25edf44ee434c80b1b4ff7a85409354d"
    sha256 cellar: :any,                 monterey:       "3829d9cd27a86fe4aea15c3860aa66af6d3bf1e5a9eb6dc8e4d0a5d3d421195a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "047e776be3ba0320295699c9bc367b4f682012a1cee39c9468b2d5bf3fd084d6"
  end

  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/bash/eza"
    fish_completion.install "completions/fish/eza.fish"
    zsh_completion.install  "completions/zsh/_eza"

    args = %w[
      --standalone
      --from=markdown
      --to=man
    ]
    system "pandoc", *args, "man/eza.1.md", "-o", "eza.1"
    system "pandoc", *args, "man/eza_colors.5.md", "-o", "eza_colors.5"
    system "pandoc", *args, "man/eza_colors-explanation.5.md", "-o", "eza_colors-explanation.5"

    man1.install buildpath.glob("*.1")
    man5.install buildpath.glob("*.5")
  end

  test do
    testfile = "test.txt"
    touch testfile
    assert_match testfile, shell_output(bin/"eza")

    # Test git integration
    flags = "--long --git --no-permissions --no-filesize --no-user --no-time --color=never"
    eza_output = proc { shell_output("#{bin}/eza #{flags}").lines.grep(/#{testfile}/).first.split.first }
    system "git", "init"
    assert_equal "-N", eza_output.call
    system "git", "add", testfile
    assert_equal "N-", eza_output.call
    system "git", "commit", "-m", "Initial commit"
    assert_equal "--", eza_output.call

    linkage_with_libgit2 = (bin/"eza").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2"].opt_lib/shared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end
