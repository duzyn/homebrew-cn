class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.209.tar.gz"
  sha256 "853d7d50e9abdcaecd1471e217e02a8c1170e5fe9baccef1ecd8f99dc022f3cd"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "293992ecd1c92f97d1b8aadceb43932b184a66eb5dcd3fb9a4ecdc999b0f27de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08167af2a7a2b0227e2b7b1a3dd662127a11f7a2a3ee1d21e77e3a23297b653f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2a1edbf17cda9e9d68e3a5c243a93717c68035e832c38e476837936549a39bbb"
    sha256 cellar: :any_skip_relocation, ventura:        "d063ca11a6ab4bf2bb82cd4195bb98bad5135edb2f6b1c9e69e4b523379c44b9"
    sha256 cellar: :any_skip_relocation, monterey:       "b36720a8f9ce13b9ada5c3b6c4c518c6d142739f5a90b389c75c9ab3df2aaecf"
    sha256 cellar: :any_skip_relocation, big_sur:        "e191fe87429e3e08950037059b75f7cb7f030fb9232a5ef1807edee650cbe6a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7907c7911313477a60d3a5b143799769f5b764b1888adfe150370355a31aa467"
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
