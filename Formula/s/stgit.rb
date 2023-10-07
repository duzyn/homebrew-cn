class Stgit < Formula
  desc "Manage Git commits as a stack of patches"
  homepage "https://stacked-git.github.io"
  url "https://ghproxy.com/https://github.com/stacked-git/stgit/releases/download/v2.3.2/stgit-2.3.2.tar.gz"
  sha256 "8d337a9e998c8b7e5ad5b0d061aa65c241071b6af5274ab2bc796fc1e8c808d5"
  license "GPL-2.0-only"
  head "https://github.com/stacked-git/stgit.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "84e8dfa1b235b1bdc5b22f08b66d76374600c6bb99557b313dfe071b5cadfbc7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "59b2805f039ed3b95d64457043f19172040040b6453167e5cbb6d0c9a4b9e660"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52797a389997a7ce0718c656985c995311e8e82137b82f15e3ae9ce7f952a6f3"
    sha256 cellar: :any_skip_relocation, sonoma:         "585157d757e420d7b2bb81c61566ae534bd397691c900521cfedba38527faedb"
    sha256 cellar: :any_skip_relocation, ventura:        "4596bcdb71391b41e5429e54bedf8b8d874d048b4edfc00a0e2629719f8f02e4"
    sha256 cellar: :any_skip_relocation, monterey:       "3ddaa68eb197262df1b93c369dda90a6abb5793e28ced6a76faf16d8cedeab25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70fa52f6c8b0f692a6c39bbc8a5a7c6e657aa8b59d2c37ea8e242c30ec8bfd21"
  end

  depends_on "asciidoc" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "xmlto" => :build
  depends_on "git"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
    system "make", "prefix=#{prefix}", "install-bin", "install-man"
    generate_completions_from_executable(bin/"stg", "completion")
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "brew@test.bot"
    (testpath/"test").write "test"
    system "git", "add", "test"
    system "git", "commit", "--message", "Initial commit", "test"
    system "#{bin}/stg", "--version"
    system "#{bin}/stg", "init"
    system "#{bin}/stg", "new", "-m", "patch0"
    (testpath/"test").append_lines "a change"
    system "#{bin}/stg", "refresh"
    system "#{bin}/stg", "log"
    system "man", "#{man}/man1/stg.1"
  end
end
