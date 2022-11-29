class Graphqxl < Formula
  desc "Language for creating big and scalable GraphQL server-side schemas"
  homepage "https://gabotechs.github.io/graphqxl"
  url "https://github.com/gabotechs/graphqxl/archive/refs/tags/v0.38.1.tar.gz"
  sha256 "10093f0050f1034a147d06313aafef1e9efcfd158d157cfc27aa79d12e5b3291"
  license "MIT"
  head "https://github.com/gabotechs/graphqxl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93d6f8d6ad4026241875b01a7631ed0ce8793ad92d216b06d3ced52793ac26e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c542b56c5e57979446ae3feeb9a7bf9108c2d8225b37d3407eec13b31ef12b9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f440a7b0ca5121fe2c789be2eb4870b834945f0fc4a3ed406f9114b92899fef"
    sha256 cellar: :any_skip_relocation, ventura:        "e99b5fd25c412d09dd6629471a653542168d9f881ea3c41cd3adf2126859bba3"
    sha256 cellar: :any_skip_relocation, monterey:       "ac92d1c6d96c69e15af0a891b181822bad206a16e0d4ee696db7712655f74167"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e80301fb8981e95e0d8fd5e287ee59b54081b6e84475fdd4a23b1035661743e"
    sha256 cellar: :any_skip_relocation, catalina:       "0a8154dd5df892706a318e38b74fb0e9a8222f81e6d19e0cee8a0ef4a6546336"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53a816a187eb523a2e070a4747ba164aa34f24486797c930524b695e559f6d6c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    test_file = testpath/"test.graphqxl"
    test_file.write "type MyType { foo: String! }"
    system bin/"graphqxl", test_file
    assert_equal "type MyType {\n  foo: String!\n}\n\n\n", (testpath/"test.graphql").read
  end
end
