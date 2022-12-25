class Page < Formula
  desc "Use Neovim as pager"
  homepage "https://github.com/I60R/page"
  url "https://github.com/I60R/page/archive/v4.6.1.tar.gz"
  sha256 "5de1939e72441bb6321facb4320f2f0d630447ee09824249490ae6af0ade6610"
  license "MIT"
  head "https://github.com/I60R/page.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "956e8692356de40852110fde336947eca13e690dca5458f1f375c95f6b8892e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "999fb11ff1130980e9a2c2aad7509263e58e3aefeaedbbe16f9e29852d9b8a7c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a8e080aa31f2914be5c222914071e86fdf603807a2bbe442ab24afe5949b8db3"
    sha256 cellar: :any_skip_relocation, ventura:        "8647bd3061b0112a979f0747651092ce04ed6ba13ea1e02b05210e03700e330c"
    sha256 cellar: :any_skip_relocation, monterey:       "8eaef816defed3e1d33f129f10fc2de7229a3a90730cd16a55a6a67db855441c"
    sha256 cellar: :any_skip_relocation, big_sur:        "fca4c6cc3a9917ccc83aa114b26244bf730222ab55650d310fe2a5fb063926b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13be6b27179af519ca538bd9b6e61c9fa340fabf1c123048ab3d42df63443ff4"
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
