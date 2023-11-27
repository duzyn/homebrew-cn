class Ripgrep < Formula
  desc "Search tool like grep and The Silver Searcher"
  homepage "https://github.com/BurntSushi/ripgrep"
  url "https://mirror.ghproxy.com/https://github.com/BurntSushi/ripgrep/archive/refs/tags/14.0.0.tar.gz"
  sha256 "d4a57f558abe30bb272850d08850d412870fb3f942ed06932a30b4989911360b"
  license "Unlicense"
  head "https://github.com/BurntSushi/ripgrep.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0a15b404285d098ebb442073075272599335c2b852b9da270e122bd79812dc2f"
    sha256 cellar: :any,                 arm64_ventura:  "67b5296c498664852aa55e48b01c3fcf62555665584ee8f461514751373a7bed"
    sha256 cellar: :any,                 arm64_monterey: "896bbddf8719968eff44d9eec97c19f5ac64cd6360e48189ee59662bb9ad6287"
    sha256 cellar: :any,                 sonoma:         "024cd9e7d4b059568c20280baadf04850d0fc8205960ed70f586981197c50929"
    sha256 cellar: :any,                 ventura:        "326f4f06087b1f388dcc1a2535ee5ab7d2778d66e69b8688a76054978ce4e822"
    sha256 cellar: :any,                 monterey:       "c4b60762a8e311f3b372ee79ffcc96f7c276e8c9e82966b7f805c3adc90db9f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7444c4b6eff0242b8570ca60f412a93117a1603a50c50010ea196a1ec944b68"
  end

  depends_on "asciidoctor" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "pcre2"

  def install
    system "cargo", "install", "--features", "pcre2", *std_cargo_args

    generate_completions_from_executable(bin/"rg", "--generate", shell_parameter_format: "complete-")
    (man1/"rg.1").write Utils.safe_popen_read(bin/"rg", "--generate", "man")
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    system "#{bin}/rg", "Hello World!", testpath
  end
end
