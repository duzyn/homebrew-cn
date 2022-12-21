class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v0.14.7.tar.gz"
  sha256 "cb1c01084f681f60e5825e76deb63f64cd41f360d67927acccad3a08dd3c7fff"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f00cb1665f5fd6bb595cc08d99783546dd1b87e0d0b28f345f03e98e78ec94d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b3735d928fec4a024269da1727958eaac2dd00ed4f1df343a0d39d7b7bbf2a8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "abbfbd2badf3816317851d0cc435fddc32ad183b575c733e19c243b61868b72e"
    sha256 cellar: :any_skip_relocation, ventura:        "270810f252b055d80ed0ae03aba4be41ab8bb475109520e43b9bf2fc288004db"
    sha256 cellar: :any_skip_relocation, monterey:       "951ae78a21d6352f48e6cda00149b3be05df3688994a07dc84cb958de6c7657f"
    sha256 cellar: :any_skip_relocation, big_sur:        "a3d3d4cc33e7e9d71ae9002b892d88f2acf50809c8302b943a264365218a093e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91e434ee86e7eae9f785920cca7fa716a3f4ecd336cd5c5e996f75b5b6b65b38"
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
