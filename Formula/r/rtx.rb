class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdx/rtx"
  url "https://mirror.ghproxy.com/https://github.com/jdx/rtx/archive/refs/tags/v2023.12.2.tar.gz"
  sha256 "03907c72e2c1095d46c99294ce35a1a58a82a96380fe63714e3bc545bff60c2c"
  license "MIT"
  head "https://github.com/jdx/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "42ebc6a21fd4fd69f36065cfd9cba401c2bf754c965653744cd14bbc25e11f2c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19242b507b23e7ae950ccd45672cbf88e12b014fe6583a16e99b03666e5f0a59"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9599b767b87f8790408c47f7f54d5168a3721c23b60e2130df06da917f127045"
    sha256 cellar: :any_skip_relocation, sonoma:         "d25c580332733e0b0492e6c970a203579578bd9be5b44bab079fe41ea61f4b54"
    sha256 cellar: :any_skip_relocation, ventura:        "4bdce933b208a828f6b480221f0f5afdb1294f4c38b14ec839a6132ea800bb5a"
    sha256 cellar: :any_skip_relocation, monterey:       "b3f79b4710572851094fba5c3786858aa76f7cec04c94dc7d1966c6f255cde5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d37a63009f83874a85ef1175bcb5bad79e1a2d95fb410378b1fce84c08ddce93"
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
