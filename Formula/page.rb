class Page < Formula
  desc "Use Neovim as pager"
  homepage "https://github.com/I60R/page"
  url "https://github.com/I60R/page/archive/v4.6.0.tar.gz"
  sha256 "b91be632d1945b65ab7411a3660fbb6f23699f5353517244de8bab0dd26902e5"
  license "MIT"
  head "https://github.com/I60R/page.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "481bcc64c6ac0a256d63af2f247c4737dfa184398e9fb409d475205096ebaf89"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0204172b568807f821693a0a8b4f0454da8eb108bbe4475f4416a55f6a717e6b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b973edd3ea986998595196f34c57119bf92d592399b9b6685a92c6240f3bc519"
    sha256 cellar: :any_skip_relocation, ventura:        "7fd5fe633dd77546befe64eed43980ce4a6802ae2766872cc4ea6f1baf0fba21"
    sha256 cellar: :any_skip_relocation, monterey:       "e37370350e46a707b77b920dfeb53b4f618edfd6301d8aba6678405cb4303811"
    sha256 cellar: :any_skip_relocation, big_sur:        "07ca801ef0dd9c23093d879db3bee754450091a16e82ac9d16be448bb59de104"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "465e1fd1bc8f7c6196bb68a1dcb4ed7cf2618d4c95b4cc1c4081ff9f5ae762c2"
  end

  depends_on "rust" => :build
  depends_on "neovim"

  def install
    system "cargo", "install", *std_cargo_args

    out_dir = Dir["target/release/build/page-*/out"].first
    bash_completion.install "#{out_dir}/shell_completions/page.bash" => "page"
    zsh_completion.install "#{out_dir}/shell_completions/_page"
    fish_completion.install "#{out_dir}/shell_completions/page.fish"
  end

  test do
    # Disable this part of the test on Linux because display is not available.
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    text = "test"
    assert_equal text, pipe_output("#{bin}/page -O 1", text)
  end
end
