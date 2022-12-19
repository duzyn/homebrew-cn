class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.186.tar.gz"
  sha256 "3e7167225e7e0124584b8745eb68b6b46015ef2d23cccd85608b4685ac50a26d"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32c0368622507007e080c27bebcc90db03c57db648b9963fe09a8b035f0c274b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86c5cf3e1f7fec67631eea78f975e9cf90118575b92557d150dfd493baaf3eff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b6279ae1de71176e5b7573ef411e16f266513702924ef3cffa64576c68c63cc0"
    sha256 cellar: :any_skip_relocation, ventura:        "dd83e49e18a45e5ee34c2740d1ae3a2e1fb7b749230157c48f8cf7942703ecd6"
    sha256 cellar: :any_skip_relocation, monterey:       "3698d821df2860af0c549ad94da72a0b91e573850017f0ec7f9397340b1cde31"
    sha256 cellar: :any_skip_relocation, big_sur:        "f34b05636d4bafff9d2175ee3921b2f71cc0b3489c14122155ec4b8e4351942f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d09c0d328051c67d9abe61eff2a0da197ab6d1b3f238dea8c23dfd4d8372dcc4"
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
