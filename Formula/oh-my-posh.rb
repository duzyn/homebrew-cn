class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.30.1.tar.gz"
  sha256 "c8ae530981bc486185767cefe91db54319af7cfd950bcb1dc14c9b1e74da9ef0"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c729ca0be9b53b66a7ac24fe19557c9f7f8c65408d556b295af70180049410f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08d740d2df2099f6e4e794a72520ba01f9829a13c207d864ae4c1eddaa6ded0a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9c585d3606de3eb23bcd62e46f4fe5749c4eeee724c7ebf27e8d0afde9d968bd"
    sha256 cellar: :any_skip_relocation, ventura:        "edc122de882823b009c834a54f3ea28f15d8251a843f3e9151f2333b16ecd36f"
    sha256 cellar: :any_skip_relocation, monterey:       "f711ac7f9ab13b4ef43cac62da3df21b3a3d1e68f7b2ecf45fba71cb8fc3dd77"
    sha256 cellar: :any_skip_relocation, big_sur:        "1370846f10fe2439a13469dfd660d238a88a88b7f300a126e35bc896beb8cbcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a10e7bdcd9c3e3dbe68fa2f0ffb1457d5017023b74cb9fba7d44ebedf9812df"
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
