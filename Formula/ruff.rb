class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.213.tar.gz"
  sha256 "868744081c26775923986768c546d0f9e14c8e961fff6ef90557dd39e3983e7f"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "94a6e3fcb693aba37310227847679f60ea54598377e02bf8da0bac61c434e0c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e7cd2e5305bcc8e01e4679d88e0940633fd1fd525c98868af4bf1a867d06f54"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c868980c31e8b438e25475db5a39d3bb8a315d095b2f8c7dea02405aaefd20e9"
    sha256 cellar: :any_skip_relocation, ventura:        "bfcdb73b4550cae94525275d8734edf21c619474bfa45df359a96ececa59acb1"
    sha256 cellar: :any_skip_relocation, monterey:       "4e335529fddb4c8e7f71138652625168a3c9878507877082fa224fa7aaf60e9d"
    sha256 cellar: :any_skip_relocation, big_sur:        "ed6e9af33969959ff291fe0dbb4df50f8a7d1d1244a9e856cf9ebf37bb5cd5cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4ea22f05d3703a9fa24894357d8b346f1c39c37203ba3a06927f21032876cbe"
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
