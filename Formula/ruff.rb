class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://beta.ruff.rs/"
  url "https://ghproxy.com/https://github.com/astral-sh/ruff/archive/refs/tags/v0.0.281.tar.gz"
  sha256 "4ba81ceebdb1d5583c815a993fedf3c20abcc4653d5678ba33b2ae6115b7d3ca"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a246b38adbdebeb9a88637c146dc092832ab0effcdef53a788b0ccc99bd1a01f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e1a95b7b5e5009ba0485fedc4a1fe8a877757504b2b2dae36f31977c781537e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "688a6d6b5cf66e18f06567400d49835bb1ec6820a316c45abfeec15b7f18ec4d"
    sha256 cellar: :any_skip_relocation, ventura:        "057734c1f177d8e49d4ff71e9528509002cdc83ee795e1af36ae6921daf6aa91"
    sha256 cellar: :any_skip_relocation, monterey:       "b21ac9d36bc5650bde50625ed1a5c2687e3a3cf7e3221f56b8657f073f6ca00d"
    sha256 cellar: :any_skip_relocation, big_sur:        "93997f7d29ab93210ea6b41b67eaf00f0e3700f0c5ca86373ac23c1088d6a4bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ef8cabb9156e58e00b43f75b7ff435779bb591a0317e356f90005b1f951fb85"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/ruff_cli")
    generate_completions_from_executable(bin/"ruff", "generate-shell-completion")
  end

  test do
    (testpath/"test.py").write <<~EOS
      import os
    EOS

    assert_match "`os` imported but unused", shell_output("#{bin}/ruff --quiet #{testpath}/test.py", 1)
  end
end
