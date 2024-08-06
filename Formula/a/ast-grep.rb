class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://mirror.ghproxy.com/https://github.com/ast-grep/ast-grep/archive/refs/tags/0.25.6.tar.gz"
  sha256 "aafa3ecd15bea5288ab726d9c9eef2acbf7a68f9601f749a7c5e2599857d38d9"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6c955238c11c8f6a92cba854f5ab531bd6ea310ab79e307671fce1308046116c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a79ce9becc12cf4f9dfc1d920e7ca101d6d9686c703cc658ac5295201cf6eee1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b91e9c1bb0917579c7142f86d8faa6057707490c3d2cc7c0f14d35b73cb473e1"
    sha256 cellar: :any_skip_relocation, sonoma:         "070dd3708b66188968eaecf6c6042a258f0b427e6fec4ef827c2748eaf42e692"
    sha256 cellar: :any_skip_relocation, ventura:        "5ec0f3813828878ad25420df711b1c0280d7c807602dc18cde8da4af393b1d52"
    sha256 cellar: :any_skip_relocation, monterey:       "9ce0c809e5e1a7a3b85b8da854c9df42db7ce28b2c5e9118b9bfb606c042358f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16233c342fdc2d44dc09a8f388875f6df2b5a778d141c5e4600d695d4b3ec112"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")

    generate_completions_from_executable(bin/"ast-grep", "completions")
    generate_completions_from_executable(bin/"sg", "completions")
  end

  test do
    (testpath/"hi.js").write("console.log('it is me')")
    system bin/"sg", "run", "-l", "js", "-p console.log", (testpath/"hi.js")

    assert_match version.to_s, shell_output("#{bin}/ast-grep --version")
  end
end
