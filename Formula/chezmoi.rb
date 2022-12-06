class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.27.3",
      revision: "feab4e788831e803d84a544739dfb8188245deae"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca5c2d696ce7f7d9b196087a31f95a6d8109682f6e73fcb64105c8f354745a3f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e9c613f2a5e9c8a470cf20bc0b5341e6a45b232917904f2d2f00ce9f304aa9e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "24206bf79c36a80355df6b5544f27b4f42a5818b47e166e9ff34b8493491272e"
    sha256 cellar: :any_skip_relocation, ventura:        "07de307ff68eaa0a18321027cba9f026276a24b37331966c3fbf427950b1b917"
    sha256 cellar: :any_skip_relocation, monterey:       "476d3e330d72ae0388710aec9004bc392b4c0441fd1522c076d1b67a5ce4887e"
    sha256 cellar: :any_skip_relocation, big_sur:        "2662f381c9acc248298f1cdef9be94f47185997f000221d597a417c643d54468"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d998e93d981356d285318f9a636ccba64b44f74c44e7cd3462e1c300b2954f0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.rfc3339}
      -X main.builtBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bash_completion.install "completions/chezmoi-completion.bash"
    fish_completion.install "completions/chezmoi.fish"
    zsh_completion.install "completions/chezmoi.zsh" => "_chezmoi"

    prefix.install_metafiles
  end

  test do
    # test version to ensure that version number is embedded in binary
    assert_match "version v#{version}", shell_output("#{bin}/chezmoi --version")
    assert_match "built by #{tap.user}", shell_output("#{bin}/chezmoi --version")

    system "#{bin}/chezmoi", "init"
    assert_predicate testpath/".local/share/chezmoi", :exist?
  end
end
