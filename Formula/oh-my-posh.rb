class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.26.2.tar.gz"
  sha256 "585fe15e2687dcb948f7cc46ed07b8ff7b6131222f19bf8b67d75240479140b3"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ad94830e798c4e0f05b617350161c40405842674cc37d536fd98cb8156ba77e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93ff11b39d13823de7a13a0110a832e5ccf1475f65006fad79737ed84d9a11e2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0d3c82058933c594dbcd40fc584f235df88c467d5d788f236e95e1dfa9817207"
    sha256 cellar: :any_skip_relocation, ventura:        "dad8d3f86dc9843a1251eb676e460940b23b9e1b7d8b22e0d85ebc97f7e5b385"
    sha256 cellar: :any_skip_relocation, monterey:       "371a6063a9ec6fc18c6961c2679fcb366f5298f1b2d46178430a846259df3cdd"
    sha256 cellar: :any_skip_relocation, big_sur:        "7070f81e4ddc15638f3538d50333a58e447fa782bb74b7f9b9c61d11f438cec4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9faeaae168fe248d88e51d1e24bc89421bf9342c0153394bfb2e8fa49e4c06d8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
  end
end
