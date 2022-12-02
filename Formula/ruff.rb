class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.149.tar.gz"
  sha256 "be46985f8557c02830ef73c5f562acf799852ff57c1e7a8c9e4fe81872961e6a"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "907bedf5e116600ccc9cce04c50895264609d9ff34a445768156ceb82790eb1c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "857ba6ee11e2b72a72881c005e6bb1bcf534d13b9ee69527a8b9f56784b8ccf2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ffb3cac3d41b2fad099953572cae2c23dd6e8c4e652965536b6bbc8e67bcb185"
    sha256 cellar: :any_skip_relocation, ventura:        "77d22156e45f1af755d87c656570679e0c706fd19bace848584f03acf3597cc7"
    sha256 cellar: :any_skip_relocation, monterey:       "90010d8f8af6666020b97098dbf510e9a97081b9e51e9dd7c9221896a53199ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "eb6a7f8af9042433d1d20c9232cfdacf8cf3e26a0bc3138a98fa172bfb474536"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fd0c70a2d40fa6b44e1f8b6ad55403e261d348c6ef81965f6dc045d63c8cc18"
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
    expected = <<~EOS
      test.py:1:8: F401 `os` imported but unused
    EOS
    assert_equal expected, shell_output("#{bin}/ruff --exit-zero --quiet #{testpath}/test.py")
  end
end
