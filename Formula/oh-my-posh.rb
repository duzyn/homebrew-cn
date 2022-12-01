class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.23.0.tar.gz"
  sha256 "c9bf15f9049252f9d591410e6181640b9cf17f34997afda74fec159dc5327b99"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fcf8c898d68b403dba1b8604ade21eaae1d6c4595985ef117cb9ddc955c1e974"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "152397a4813f097582ff59c1fa8aa53bb02a20bb2ad3ea96420089df8b293a2a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ce9c4d608ba5bc24d6f6c42ada5f795d6ac96514bd5fe1fcfb41f488dc7a9bf9"
    sha256 cellar: :any_skip_relocation, ventura:        "5388abe8558eccdd8e585ed4a6e920e39df5b36534d44b87ea1f733c02417286"
    sha256 cellar: :any_skip_relocation, monterey:       "fe779eb2d5b58c2ae764496eb9704561ae1fe5eee9f8a0e38f4d89e182d6f27d"
    sha256 cellar: :any_skip_relocation, big_sur:        "51bb5497b5a0d6cfa0dc70ddb0c3f8792da6f1857c411f1a03c7afa50aea42af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5ec14384bd2e9c73054b88cb8b621ba9bf89aca6bb4ef283ccc05932a278193"
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
