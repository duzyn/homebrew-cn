class Wasmtime < Formula
  desc "Standalone JIT-style runtime for WebAssembly, using Cranelift"
  homepage "https://wasmtime.dev/"
  url "https://github.com/bytecodealliance/wasmtime.git",
      tag:      "v4.0.0",
      revision: "24d9253f0ee79f48b8d73d6ee3da257f4f579baa"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasmtime.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "20717afa00fb7c9930b271ffca2ece2b255cc6eb4ea606eca3d99f33e070cd04"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d341def3c88798f282a289da49b61c5bcb60831bcb1c514d38ae998ec5ba30c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f52a8dfbc63196039be2ac33680b476260ca62e8a4381d77893c1d0c3cf8d366"
    sha256 cellar: :any_skip_relocation, ventura:        "70220e4738782f1469622dc6cf9f691533cad7da9f30abb6ce5226f509d56289"
    sha256 cellar: :any_skip_relocation, monterey:       "50def46a2886d95c46e3abf16e44f4bea31b2d89952cf8e147f2271371310c10"
    sha256 cellar: :any_skip_relocation, big_sur:        "2f0ae876751a9fe9a06f814600b648e209028d08d03b393c8ba52b18f5b06f24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0136e4b6ab439091ec1e38256216c43313dcd512c56497c37788a38874eecf9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath/"sum.wasm").write(wasm)
    assert_equal "3\n",
      shell_output("#{bin}/wasmtime #{testpath/"sum.wasm"} --invoke sum 1 2")
  end
end
