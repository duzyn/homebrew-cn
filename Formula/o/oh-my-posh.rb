class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://mirror.ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v26.17.1.tar.gz"
  sha256 "bb2c7d85540f7b01d410ab908bc423017f99426507b1bd8c2abe5043690c2b27"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95a95efbf14d696b3e60d3d8043c24bc761d23bf6afc2da9a6349bdbab98396a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34307ab3cdc11bee465db341af0ad3e402da0b86249c2d95abaaf6fa1ba69e4a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "21ab8598d5bdc1e7d3487f4924021b7b46e4aca89531f47fb7c53d0b603c3344"
    sha256 cellar: :any_skip_relocation, sonoma:        "991294587d47fb415c8a50c50fd6059301561e65f99b7ee6f7cde235a17120cc"
    sha256 cellar: :any_skip_relocation, ventura:       "bfbed68e1af93e05a531a3b16c05e0e06aae78a0f3d7879ada30cec7f83e1f93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7c95aa0bdaa90c169fde89f370b6c6810b8a0e6aac30d5137c3876832541381"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]

    cd "src" do
      system "go", "build", *std_go_args(ldflags:)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh version")
    output = shell_output("#{bin}/oh-my-posh init bash")
    assert_match(%r{.cache/oh-my-posh/init\.#{version}\.default\.\d+\.sh}, output)
  end
end
