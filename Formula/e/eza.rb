class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https://github.com/eza-community/eza"
  url "https://mirror.ghproxy.com/https://github.com/eza-community/eza/archive/refs/tags/v0.20.11.tar.gz"
  sha256 "1a3ec9fb87c61e2369b46945ff1fafb7cbb5e6cb4693bb59003f4b628a93a04c"
  license "EUPL-1.2"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "342d44b62784a0d50b23ee1533ee013b085a458c3a9040714029c715b24b0ef4"
    sha256 cellar: :any,                 arm64_sonoma:  "d34e8dba87f2e388ea7778ac664a5895a5cc5c6ea075282d25fdaf4cfe705cea"
    sha256 cellar: :any,                 arm64_ventura: "19a8d8ce8a3c56c7e31bb9996cecce17afc0360616b29a89508828e39cb61d68"
    sha256 cellar: :any,                 sonoma:        "f61572500bb9eb8a9bdf3a26bc3c75a809ba83094305f763578affff2224ed8e"
    sha256 cellar: :any,                 ventura:       "e81cc5ea29d8749cf85e4a452a116c6802b6aa729592991230623fd04d91cc32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00fba409e626653c3369849a94d745758abd7078c7c4db13e63a249ebf221033"
  end

  depends_on "pandoc" => :build
  depends_on "pkgconf" => :build
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
