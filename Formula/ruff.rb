class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.205.tar.gz"
  sha256 "cdf64d2020a3695404f35fc7bd6ce53371ba6103e2c5522584af4bd8ce305f6b"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3d3392d7b4d0ace034a9ff9e9f43a15b3d573799850e2f8166d728d805bd0f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa5644330d5ec504ba1705abf80a84b238760c053c7497e218d889e7d289a62e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "44a4ff4f63e53e1a5ae2c1fa2feff46cb4e264837c6f18a0ea80b0bb25dfdc60"
    sha256 cellar: :any_skip_relocation, ventura:        "72b90039cb01c89b0e51014ca527ce1442463022c5df5a87f08c94c1b0e474a6"
    sha256 cellar: :any_skip_relocation, monterey:       "485b054f388fd878dd93b441d0c1aba6be569213087d312ce785051934481f44"
    sha256 cellar: :any_skip_relocation, big_sur:        "1fe1f7597f278dae59da469a1113d234631c8960fb5e369e81b0f6cc600d71da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e0d420604fc759d738ad1cb4c836afaeaa1915a1f79c3edfc18d528feb15f18"
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
