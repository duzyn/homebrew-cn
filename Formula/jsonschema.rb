class Jsonschema < Formula
  include Language::Python::Virtualenv

  desc "Implementation of JSON Schema for Python"
  homepage "https://github.com/python-jsonschema/jsonschema"
  url "https://files.pythonhosted.org/packages/36/3d/ca032d5ac064dff543aa13c984737795ac81abc9fb130cd2fcff17cfabc7/jsonschema-4.17.3.tar.gz"
  sha256 "0f864437ab8b6076ba6707453ef8f98a6a0d512a80e93f8abdb676f737ecb60d"
  license "MIT"
  head "https://github.com/python-jsonschema/jsonschema.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "23e4639d5e5067076fb6c92d35a03b1d427dc31d7586d51c6e7c255c55439a1e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18aac6c452ba522914a5fce4ba6d29aa60b4bf5102cea0c961f20634f70adbc6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "00ab626e232e11ac3063b31155ec14847a160f7bdf1691b085a0b182ab83a25c"
    sha256 cellar: :any_skip_relocation, ventura:        "69cfdad96ec414d52f2fcced61d0cefaffe6c09d3b68ee873d9e0773624ea9c1"
    sha256 cellar: :any_skip_relocation, monterey:       "e6448be32e737ea48641e110086d1ec770ce797bf9f302ab0b4321433b5f939c"
    sha256 cellar: :any_skip_relocation, big_sur:        "00b202b6f536caccc0400307494ce3cbd528fc78a2f8c0a225e61fe3ba2dba3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b553a0c90869652654d5c4f779000f244f109d1ec6b7938c5b12db000d054120"
  end

  depends_on "python@3.11"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/21/31/3f468da74c7de4fcf9b25591e682856389b3400b4b62f201e65f15ea3e07/attrs-22.2.0.tar.gz"
    sha256 "c9227bfc2f01993c03f68db37d1d15c9690188323c067c641f1a35ca58185f99"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/bf/90/445a7dbd275c654c268f47fa9452152709134f61f09605cf776407055a89/pyrsistent-0.19.3.tar.gz"
    sha256 "1a2994773706bbb4995c31a97bc94f1418314923bd1048c6d964837040376440"
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
