class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.37.0.tar.gz"
  sha256 "2da26752737eab20cfffa369814faffd522181ec8819abd523b8c1abb1a349b4"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "627ed32acfbdc084770b7a930dc5bf24c75ec24f94cfaf6c812d581cdaba7e03"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a7aef3fec3b543d8f364c48251db3c11056a88a78a591a7f77ef0557f489a36"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d91263deaa2cde22f2e2245e3cc4f279e39b4b0c4a448144fdac2488bb10c03a"
    sha256 cellar: :any_skip_relocation, ventura:        "f8dfad8577d03caa4677d2b71bd38e2650b31863284b15288f8ee7d0bb33e3b2"
    sha256 cellar: :any_skip_relocation, monterey:       "90aabe0f29addc7a731dad179bfc97a1060cbbdfc6ed0f8aa77c2c5f1957f28b"
    sha256 cellar: :any_skip_relocation, big_sur:        "31752ad4d5c1cb1e1bd66ad428e947d4e09d09f4829e9dedb88c7b20efbd73e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "911c290cc621433ae595d1af2ac4f2b08bcb64b3f98a861878bdf7d708a60a83"
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
