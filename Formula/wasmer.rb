class Wasmer < Formula
  desc "🚀 The Universal WebAssembly Runtime"
  homepage "https://wasmer.io"
  url "https://github.com/wasmerio/wasmer/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "d3a27e5fd834573a226374e0c5ed8891af9fab41749efa2aecbd3d22c3f950a2"
  license "MIT"
  head "https://github.com/wasmerio/wasmer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d6017c4d946b76e3bf4939a61b19f13bbf5b5586503bf5e31af2422964495d84"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d9ea5ca98a3ab07546219dd392ef9fbbddd1f4f949b8801dcc395aa4a24bf0c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "15be174a58d9431bf17a7e56dd9ffe4bd07be658be90fb4b147701fd164b7087"
    sha256 cellar: :any_skip_relocation, ventura:        "c0140b3618bc520f0263e773c189cc9b2b77318601c531accbfe04e9ba698538"
    sha256 cellar: :any_skip_relocation, monterey:       "c4fe4ac203def14a8577966655aefc91146c814704af2e9a8549a9599cfb08ce"
    sha256 cellar: :any_skip_relocation, big_sur:        "103d17e2c081987aab9f3bf0d96dc2eac8529ffabe79859ef0d87f7328a45c3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e6d6dda41052ecace71a5c1394ab9791358df62e4874125d270b5a9d0c17406"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "wabt" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libxkbcommon"
  end

  def install
    system "cargo", "install", "--features", "cranelift", *std_cargo_args(path: "lib/cli")
  end

  test do
    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath/"sum.wasm").write(wasm)
    assert_equal "3\n",
      shell_output("#{bin}/wasmer run #{testpath/"sum.wasm"} --invoke sum 1 2")
  end
end
