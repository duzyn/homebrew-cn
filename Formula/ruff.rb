class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.193.tar.gz"
  sha256 "ed29800ca1087ceeb046483ba8914c7441fc2b561d4e5ba71d57935b8b5268bb"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74e7fb0553571a557c5cf50cdbd80240df6e52e643e9d4add157740de313041b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2efe73f5d5ecd88d5c70a6b1a37337b6e2763ef404514eae88a1a9c605cceb35"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa51676541ec16dd642a7017f17710d0e5d316c392f9c53263821ff4afee9d57"
    sha256 cellar: :any_skip_relocation, ventura:        "24c6d4985d94f718f4b502901455917e61ee293fa9423df049e41a6ac65c2b53"
    sha256 cellar: :any_skip_relocation, monterey:       "b06c18059ebb70cef388fbe8c87d87a3030c18542a95c191bc26bc8d8ba2b7ee"
    sha256 cellar: :any_skip_relocation, big_sur:        "287f771b3ae93733315495bd8950ccb820c3ad0d287422b668994613bce480e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7a4bf1792f10ef1857dba1a6071290bddd35fdd496e3fb1e98e3cd45ed2a0be"
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
