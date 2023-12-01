class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdx/rtx"
  url "https://mirror.ghproxy.com/https://github.com/jdx/rtx/archive/refs/tags/v2023.12.0.tar.gz"
  sha256 "8f5b71b06315c5f6cc28ed5e5864288e6808a6867249bfffe8b6eb174a22fde7"
  license "MIT"
  head "https://github.com/jdx/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "92f8dc79fd46097b0ecb69b3d8ac0d6f48c30d18fcd3664066bec2a92eda5c5b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c6f2be2aa11e193f2699b3855a8a7959b9a7f2c8d5baded2171be6fb27165441"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8d7f31d921495e432c5e3a7ced8906256dd95a0429136a05eb5d884e8ec25d4"
    sha256 cellar: :any_skip_relocation, sonoma:         "17b29132d906dcda8c23c1272c0843434dd26a5c4fd396397d561f068d5a466d"
    sha256 cellar: :any_skip_relocation, ventura:        "07006c387286276ce3f81e869a55cf963347c853cc599090065dee921bc90397"
    sha256 cellar: :any_skip_relocation, monterey:       "1e9f6ac20efe8b0654353a4a56787e3e0cfe7e86883b16951c59d814e0e2b9c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e08e409cea6ce4f6324e7531c2490a99976f2982c2d6bbd59bb68249ef85164"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", "--features=brew", *std_cargo_args
    man1.install "man/man1/rtx.1"
    generate_completions_from_executable(bin/"rtx", "completion")
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end
