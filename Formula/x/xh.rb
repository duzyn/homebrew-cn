class Xh < Formula
  desc "Friendly and fast tool for sending HTTP requests"
  homepage "https://github.com/ducaale/xh"
  url "https://mirror.ghproxy.com/https://github.com/ducaale/xh/archive/refs/tags/v0.23.1.tar.gz"
  sha256 "3f7dc6a3c8809f57a32c9aae7a192b54e87702a65d426784c1775676eea2e67f"
  license "MIT"
  head "https://github.com/ducaale/xh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3701110007afd28ac6623dab0ddd121af704ca4cbf12dcac2ee5a5df8c112247"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e13c6f73d7eec083c51c16846aa013f921dcc9e1902bfed1c53d4dd07fb934f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bebe7b9416c66728a7174c6eaf3dbb093da30e6747d7b4600527c1d66edb84a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a1b001fa8574400fb7d1c1c732524498bd9173a0338ab8d9d5ebc35d0c02be2"
    sha256 cellar: :any_skip_relocation, ventura:       "da6bb99294255abaa59c5c2b09a9dd2478fe7d13af3c09f1253f4f20b91ad6da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30a6d87170d1b259226474c8667ea6ec9e7cdfcf9e6deab3e5d25e5fb0928ea5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    bin.install_symlink bin/"xh" => "xhs"

    man1.install "doc/xh.1"
    bash_completion.install "completions/xh.bash"
    fish_completion.install "completions/xh.fish"
    zsh_completion.install "completions/_xh"
  end

  test do
    hash = JSON.parse(shell_output("#{bin}/xh -I -f POST https://httpbin.org/post foo=bar"))
    assert_equal hash["form"]["foo"], "bar"
  end
end
