class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdx/rtx"
  url "https://mirror.ghproxy.com/https://github.com/jdx/rtx/archive/refs/tags/v2023.12.22.tar.gz"
  sha256 "ecf01f0524bfc66c81091a8fd5586cbb17fe706d159a55e7e434193e8a56a379"
  license "MIT"
  head "https://github.com/jdx/rtx.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b6d6afc6809d4069107fb50d1966acbeac7a141d6ec6b6cef80cc5d98d81a769"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf3a8dd875b080657feb5530e4bf4ec0aecd50d5ac816b798355209e8e81ed76"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7991db55c6e79c289a1edbd8dab055c0190df64fdfabba7ee1a9acda74460e84"
    sha256 cellar: :any_skip_relocation, sonoma:         "8a4bc31581c59118c3c186070b88be17b82f245012cdb5b805ee5b45de7fba1f"
    sha256 cellar: :any_skip_relocation, ventura:        "f958dc2d8883975be504f609f0512dc09f29799fea72c7514eaf3b6d1bfd8022"
    sha256 cellar: :any_skip_relocation, monterey:       "06ab03db40e383f90b47a0ace113ae6ab988ac80752e902b5a856c33009c8b6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b82871a31063bd08b3c8e8739c8f89bc71e15f388a9d45cbc2c6171b43456f9f"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "man/man1/rtx.1"
    generate_completions_from_executable(bin/"rtx", "completion")
    lib.mkpath
    touch lib/".disable-self-update"
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end
