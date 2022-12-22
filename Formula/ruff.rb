class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.189.tar.gz"
  sha256 "e0e1b08d39bc879273cda920ecbfd919cbfd2be62253c09f3e9e468fb6b1e63a"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85359c2d1ee724f4f7dfb4136b37290939315eaba4c703c81fcf61b38b872525"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75b534cdcfd1c528dda38f8fb097a812635347a3d6b8613f0c7b633f293a7eae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f4b4b091e5dcae26580813e70793bd5bfc4961415549705b6468158322d44a7f"
    sha256 cellar: :any_skip_relocation, ventura:        "9c9d8a00e0ce32c2302ec565320b01e22bf0728f78848e34b76a5f8d4ac13843"
    sha256 cellar: :any_skip_relocation, monterey:       "3272eea0b877086d1fcf131900002b2c306137576e7c1cfdbffbe94f457fe089"
    sha256 cellar: :any_skip_relocation, big_sur:        "e732c9fdbeab0f6f1115a555a6af0c5b123f23d87adfde8eba8e520d4b767fcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf6d17f1e70ac57b90348a92a5b0016b14cf73456c621a74b3c664611b906e4c"
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
