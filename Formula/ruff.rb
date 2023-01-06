class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.211.tar.gz"
  sha256 "2b39199cdead25b68727724151003edc43efb9fca327ab634926b14d0a6acba0"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bded970767cffad8020eb5b334bf65861243cb15b0ae32f763e35ab411c36110"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a7eb86617b2e6c9d9569a1049137a8ea922b45f63ca9faf26ee6307f6c62b04"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6cbe77daa13936fa0639e8f4dd87f3baa1a917a262de20ae98fc42839bcbc6b8"
    sha256 cellar: :any_skip_relocation, ventura:        "723a16abb39864e2aa1a93b8a08aa5e8affee20333c4813533c30483d8618b96"
    sha256 cellar: :any_skip_relocation, monterey:       "aeb87637c0a902155fedce39de4801bcda5dc769f87e67c3f2c162dc9052f62d"
    sha256 cellar: :any_skip_relocation, big_sur:        "01b26f0d8444f9f43fa8a43f0c13139c4babad4e1a4d5443c2318c5d6bb56088"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8d614c80b4debab72e441251a8d6810caef0036b3d07537ad425da36cae7058"
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
