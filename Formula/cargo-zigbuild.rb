class CargoZigbuild < Formula
  desc "Compile Cargo project with zig as linker"
  homepage "https://github.com/messense/cargo-zigbuild"
  url "https://github.com/messense/cargo-zigbuild/archive/refs/tags/v0.14.3.tar.gz"
  sha256 "dc33ff93348ae13bffffc8577a35b3656f5c56d35acb4379dd0da8e5663aea19"
  license "MIT"
  head "https://github.com/messense/cargo-zigbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d995631c656b64bf942c4b5928341d45411fc1ec98b25f9c8a72bf54dbd7776c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ce193c0e6dd68afc0e609d3b3e25908f47309a283a3c616e4c4a99c54bf0ee4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c965045f3e5344df1ec11fc5fe78af19ce36e6a484d6b7e5746f9d37b11fc365"
    sha256 cellar: :any_skip_relocation, ventura:        "642ffb79e60fc672f2ab9aa256fef7c6e74087fe1529cf33a5776bfc7fcc7100"
    sha256 cellar: :any_skip_relocation, monterey:       "94a36979327a8fdc8db739d93516ccb435efa6bbdb9c0e6cb9a972061fbd2989"
    sha256 cellar: :any_skip_relocation, big_sur:        "815f7fa1a121effbcbc4bf61671809936c3dd661903277efa2585dccf555b252"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7854da299024c4048cad91cc7c8eee7cd383e83a3e35a99f0a54fd1067f1d319"
  end

  depends_on "rustup-init" => :test
  depends_on "rust"
  depends_on "zig"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # https://github.com/ziglang/zig/issues/10377
    ENV.delete "CPATH"

    system "#{Formula["rustup-init"].bin}/rustup-init", "-y", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"
    system "rustup", "target", "add", "aarch64-unknown-linux-gnu"

    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      system "cargo", "zigbuild", "--target", "aarch64-unknown-linux-gnu.2.17"
    end
  end
end
