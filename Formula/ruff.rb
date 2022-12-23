class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.191.tar.gz"
  sha256 "73cf8b8b1a2c51e5b24e5854c5cf0e359d13a2d8a2cffa6085d14a2e2b659386"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7159d42278152743a4726280a7b4d50f4ab6592740ff25356938a74e6cffbae7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86a37c9f3c42b1a7d314d8bf88a9a866fe5336e61e65f083de34e7fb93fdf953"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4ed9d10dae3598f6efd42204b63818885d1043bb36084c01fb01ce51fe34c523"
    sha256 cellar: :any_skip_relocation, ventura:        "e06ad5c9470341b9824c6bd2a3f33ae4b4e103a620e6f7dbb6b9e26260fdc189"
    sha256 cellar: :any_skip_relocation, monterey:       "e6a532cce7a0230caac994da7776941507d27d3a9506681544119062fb111cf4"
    sha256 cellar: :any_skip_relocation, big_sur:        "166113ea7fb112b91259b59ae5c41371e87abc98b0e84e4630349197ff9fe945"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a621e43f78b12671f9c3aa1596c620ca1695bd658be0090dbe2bf41ffa0bc4f6"
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
