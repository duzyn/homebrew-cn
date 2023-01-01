class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.34.3.tar.gz"
  sha256 "6d644e07a6d4dfaa51fd4a22c047c5dadaafb13797602265d64c74bbab180b96"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "73fd0a0f1bea7571483cb06d8a633479bd3bed256813ceae030b2beb0422b4da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43653eed232aa51837dbe906d3e535fe7e016fc4d5131b6aecef625d5e388f9c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ec33e93e89df6d250a1fa4106b5bafee68d02da771b70830fd0c096a66bbd23"
    sha256 cellar: :any_skip_relocation, ventura:        "5f818a0c0a13b3213ba17389a3489146a69fe33685c68e55a3d25d3ebbdaeb8d"
    sha256 cellar: :any_skip_relocation, monterey:       "c0b91877dfc7f7725b7546567838b782eec63c67fe711030391ad3fb61ea1cf0"
    sha256 cellar: :any_skip_relocation, big_sur:        "f61c2683136ea261246ea564e41f9a331feb4f87aed36fbc156b9739b516cba3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eaa90768167f2e4cf84028f42a0e9d9ffadda5c4c5c1c58aa7f81629e54ade3e"
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
