class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.194.tar.gz"
  sha256 "d07a30c2e7fc554a0efdb0861e0c7b34fde33699f66c0d6c140b3647e85573df"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b586df138a06cd71a23e81ed31e3c9bc472f139156357817057d4d4d9641c26"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee8f4771270afdcd4f160ba2dda28ee4c8a3f60440c6c88f0ce02d0804a741dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d3fb2c4ec1665a959e883931fa9178354e5de09fb48492e214eace145800af90"
    sha256 cellar: :any_skip_relocation, ventura:        "14d289e5489b8f430642141e4ee1476835b255a624838c390daa6f61ae4d34ff"
    sha256 cellar: :any_skip_relocation, monterey:       "311f52a8f804f04405213285930c378d292eb722ea12294ff003158aaf65e59d"
    sha256 cellar: :any_skip_relocation, big_sur:        "506033d6ca944477412143fedb641f23741485ce54aed976c0ad48db93e0cbb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0592162d78ee96c7b7d48d220a4de0eea37027458128d42aa86a736784576dc"
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
