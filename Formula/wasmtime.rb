class Wasmtime < Formula
  desc "Standalone JIT-style runtime for WebAssembly, using Cranelift"
  homepage "https://wasmtime.dev/"
  url "https://github.com/bytecodealliance/wasmtime.git",
      tag:      "v3.0.1",
      revision: "510055fd3f9d1c1404c03a89a9c6f16ab6cbe120"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasmtime.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70bed2302341a35a23b108a45a4a2eecfac4d2a11e60a06f749ce1664604ef95"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9855b73234a3496a142704c11b374deaf9f0321982a7251621216af4c1b09ece"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8dd1ccaf194302a78064abc63f8c3b3dd58cb1ebd6968517ff7567edadf1505a"
    sha256 cellar: :any_skip_relocation, ventura:        "1f9fbcfedce7a225d3552ddf34e90a3cc6a5e8381a92b7f5cbab2785f1942483"
    sha256 cellar: :any_skip_relocation, monterey:       "111093a3504cbb1cf0463b4cf4168339eade9dccd2be0849cc3cbc4f9f6fe767"
    sha256 cellar: :any_skip_relocation, big_sur:        "f416e25308146b2eb356daafebb3ed72eb76f4bd1a9afa7f5a026acc51278eed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09c728c8ccfd8030648712e9fbe0e37df4e6d39838bf53896b608f2be2996466"
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
