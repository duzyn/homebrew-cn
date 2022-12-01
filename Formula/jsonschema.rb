class Jsonschema < Formula
  include Language::Python::Virtualenv

  desc "Implementation of JSON Schema for Python"
  homepage "https://github.com/python-jsonschema/jsonschema"
  url "https://files.pythonhosted.org/packages/36/3d/ca032d5ac064dff543aa13c984737795ac81abc9fb130cd2fcff17cfabc7/jsonschema-4.17.3.tar.gz"
  sha256 "0f864437ab8b6076ba6707453ef8f98a6a0d512a80e93f8abdb676f737ecb60d"
  license "MIT"
  head "https://github.com/python-jsonschema/jsonschema.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c26cd5129a5f40259fbd68a639a8be2716772f101f3b2b221d1bc933f7a7bc5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2bf59f4a37da0c8b58947f074e5667a557a89e83529d7368f9106aa8a44d1817"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5aaf0cc515401f186bbc5a8dc2ac1c8a1b55f526990140990216b20ce7bcc9ab"
    sha256 cellar: :any_skip_relocation, ventura:        "69b4ac6fab0ebe23582c0a7ddb2dd3e62c0a26ec2a4e28daf1264a4a9cc821ea"
    sha256 cellar: :any_skip_relocation, monterey:       "c4e3904eb06d086a33ad63ea8991bf1f884ca5b386370bf7a7d167fd1e508966"
    sha256 cellar: :any_skip_relocation, big_sur:        "a2c29684ce27332a6ad33ac34d8666bb1ef2242836b70391df176cf0bf93db82"
    sha256 cellar: :any_skip_relocation, catalina:       "674cd7a0bde6a6b8c36fff283e2d2dd70c1aa9c9a5143d4f5e30a6bfb32667b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e02603ac9676ccfd62a9a457e81514df7a3cfceadaf4399e0e176ce2aea1710"
  end

  depends_on "python@3.10"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/1a/cb/c4ffeb41e7137b23755a45e1bfec9cbb76ecf51874c6f1d113984ecaa32c/attrs-22.1.0.tar.gz"
    sha256 "29adc2665447e5191d0e7c568fde78b21f9672d344281d0c6e1ab085429b22b6"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/b8/ef/325da441a385a8a931b3eeb70db23cb52da42799691988d8d943c5237f10/pyrsistent-0.19.2.tar.gz"
    sha256 "bfa0351be89c9fcbcb8c9879b826f4353be10f58f8a677efab0c017bf7137ec2"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.json").write <<~EOS
      {
      	"name" : "Eggs",
      	"price" : 34.99
      }
    EOS

    (testpath/"test.schema").write <<~EOS
      {
        "type": "object",
        "properties": {
            "price": {"type": "number"},
            "name": {"type": "string"}
        }
      }
    EOS

    out = shell_output("#{bin}/jsonschema --output pretty --instance #{testpath}/test.json #{testpath}/test.schema")
    assert_match "SUCCESS", out
  end
end
