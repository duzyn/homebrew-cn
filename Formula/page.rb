class Page < Formula
  desc "Use Neovim as pager"
  homepage "https://github.com/I60R/page"
  url "https://github.com/I60R/page/archive/v4.5.0.tar.gz"
  sha256 "c75a5f7480864c84b82378b0c6fddf34712279e13ddc1c893b2f9a83604f7370"
  license "MIT"
  head "https://github.com/I60R/page.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3480292061c77cb000bc27006db9bb8db199cd095221c735688380c1168ebf3c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f7df47c80a774ebfe494cc9d854a6031d237741c7bdcec4799ef105108290f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "58f2616585f5889290831042fff42a3feb9b14500245fbfbc31c58a880b20e28"
    sha256 cellar: :any_skip_relocation, ventura:        "a84bfed092619e70e5732c836c29073d0b8864ae12bfe5aa1d259b56a71a8731"
    sha256 cellar: :any_skip_relocation, monterey:       "8004e66991817be622875916a3fc91469e95f47f838ef748c2726743fd9498d7"
    sha256 cellar: :any_skip_relocation, big_sur:        "e8816afcf5894125ee2f266b65f1fc25f7e12f6f9d7a89aed78d6ee2aee0dc5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "675bd7bb97b0c94679563961ccfe03ca46161646091375ae06e3de98f7acaa49"
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
