class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.188.tar.gz"
  sha256 "a7201e9bc44590906a6f87caa1919070dc0baea1a08687454998724a5857ed5b"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0c264319acfef944e8a6595ccc5d9c33ea8bd67a3182bf6cfdc90806c0bbc0bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "003e12380af66a2fcb6e85b4f1839ae909a2586804a4ab08f36df8e6c74bc77f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "724ee87de5524a10c638c9990c04e462671d54ccbf2db0e277057288c98d50e1"
    sha256 cellar: :any_skip_relocation, ventura:        "610a76b777b03aff36060778b1a7ec35dcb5927815507a45cc1ec475bdf9d97c"
    sha256 cellar: :any_skip_relocation, monterey:       "5b5d37be0adb05b6ddaa6ebd8ee2625d0edd03718bcf6f843fa515e8dab4356e"
    sha256 cellar: :any_skip_relocation, big_sur:        "991d51de7d49608cf1e3b82c1d60764d607bd4678562737df51deced402b872f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f004f3bae17f26d487e074580693a9183149ec451332c7481a9a36e2d402eac3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args
    bin.install "target/release/ruff" => "ruff"
    generate_completions_from_executable(bin/"ruff", ".", shell_parameter_format: "--generate-shell-completion=")
  end

  test do
    (testpath/"test.py").write <<~EOS
      import os
    EOS

    assert_match "`os` imported but unused", shell_output("#{bin}/ruff --quiet #{testpath}/test.py", 1)
  end
end
