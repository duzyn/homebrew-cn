class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v0.14.6.tar.gz"
  sha256 "28ac0c34b55f938ba03aa123fec6b01ebec925e12ee37dd6967fa20d986d082c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db4e0aa7bb41dbb1a9b094b34db86111b3d2b148a3f0b6ab66120304f0872617"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42b84f54f4e399cfc57cd033a18b2437023f9a73ea6e64d058a393847c759a8a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "757c5c7d546ac85dcca5c91333e3b2035b3e2405c616b3e2050bbf7ee0c06728"
    sha256 cellar: :any_skip_relocation, ventura:        "225c8dc99b838e425fdb93d918c92be50594e2404c491300758f253c45e59353"
    sha256 cellar: :any_skip_relocation, monterey:       "393cf5a24d7669fc15ef08151c525afe48aefdb4aff52ff541d9ebb32993be6f"
    sha256 cellar: :any_skip_relocation, big_sur:        "66b9da9298c835e28d312367d6eee4b3ce089c317408dc1286d6d86f3303281c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3689c3a77bcdfb78fb76b672e1ca8d58ac6e72507cc1c47ec4213b1e9edf358c"
  end

  depends_on "python@3.11" => :test
  depends_on "rust"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"maturin", "completions")
  end

  test do
    python = Formula["python@3.11"].opt_bin/"python3.11"
    system "cargo", "new", "hello_world", "--bin"
    system bin/"maturin", "build", "-m", "hello_world/Cargo.toml", "-b", "bin", "-o", "dist", "--compatibility", "off"
    system python, "-m", "pip", "install", "hello_world", "--no-index", "--find-links", testpath/"dist"
    system python, "-m", "pip", "uninstall", "-y", "hello_world"
  end
end
