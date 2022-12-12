class Gleam < Formula
  desc "✨ A statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/gleam-lang/gleam/archive/v0.25.1.tar.gz"
  sha256 "87dd4d06bc2f511217efed92f9d271a450b6fc9ad74f0f286dc24df0f1b57659"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "20472b03a63022868cb559b62e329119df2297a0e4f99d6e7ccd9b844e76b852"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "743a254f93ac06998b74ad1803060b9876a081793366a36da3f986d05d082e24"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4137e0be70b14e0feb894ef6acb285d740eaca8112f661a4cbdfd25a3bb20def"
    sha256 cellar: :any_skip_relocation, ventura:        "f0c21fae9f45e69f7987da6d49fb5444cd22ca5282a706bc2c7ea0c6095470a5"
    sha256 cellar: :any_skip_relocation, monterey:       "f7cac750b2aea466d7786c48ba22990bba4b48f0fd4ee3ac26af1a12ffa97873"
    sha256 cellar: :any_skip_relocation, big_sur:        "89167584ee08c19b4d33c618b7750643f141ae9c32bdddb9e75baf85a68027c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00643f2044dd5a5982b4906e36a913aff8b254d5c8c9c8ca93bf076024356f7e"
  end

  depends_on "rust" => :build
  depends_on "erlang"
  depends_on "rebar3"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "compiler-cli")
  end

  test do
    Dir.chdir testpath
    system bin/"gleam", "new", "test_project"
    Dir.chdir "test_project"
    system "gleam", "test"
  end
end
