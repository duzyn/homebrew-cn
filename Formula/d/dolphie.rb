class Dolphie < Formula
  include Language::Python::Virtualenv

  desc "Feature-rich top tool for monitoring MySQL"
  homepage "https://github.com/charles-001/dolphie"
  url "https://files.pythonhosted.org/packages/41/68/1d05fa80bf48ee4ea8ffc548545668e8c8b06f6bd62783a786364dfbfaa8/dolphie-6.0.2.tar.gz"
  sha256 "629aed1737b3d243a481a8e89c1d8ff8f63a6010b6134c26f12bff9b7d477dfe"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "acd1961c2d22688eacd8198f5593d10b7dfb644ee4e959ed0b2d1c7cc54eff34"
    sha256 cellar: :any,                 arm64_ventura:  "b1f964e95faf37cbfcb4c0953fd0d4e71def977d769313cc47396d77572a571e"
    sha256 cellar: :any,                 arm64_monterey: "b99c0f78cd743b0ff7e0646abb32948add59dc66b6a933c4592c071ee2109c23"
    sha256 cellar: :any,                 sonoma:         "3bdfc8e17c744a90a7e66f7390b7df7a88f2889432da530a558598bd0cea1269"
    sha256 cellar: :any,                 ventura:        "4b7dc5ea68bda0009df857c729f6f7c7f6afe42c787820777eec9a1a3aa6c45b"
    sha256 cellar: :any,                 monterey:       "a43f4c6e007285b1eefece1da056b59aa50776d1a24871be946123345ff5ac78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee79fb694c1902da80cc9518951dd05584a837f7c45f00758b3e2126885d0ae5"
  end

  depends_on "rust" => :build # for orjson
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "cython" do
    url "https://files.pythonhosted.org/packages/84/4d/b720d6000f4ca77f030bd70f12550820f0766b568e43f11af7f7ad9061aa/cython-3.0.11.tar.gz"
    sha256 "7146dd2af8682b4ca61331851e6aebce9fe5158e75300343f80c07ca80b1faff"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "linkify-it-py" do
    url "https://files.pythonhosted.org/packages/2a/ae/bb56c6828e4797ba5a4821eec7c43b8bf40f69cda4d4f5f8c8a2810ec96a/linkify-it-py-2.0.3.tar.gz"
    sha256 "68cda27e162e9215c17d786649d1da0021a451bdc436ef9e0fa0ba5234b9b048"
  end

  resource "loguru" do
    url "https://files.pythonhosted.org/packages/9e/30/d87a423766b24db416a46e9335b9602b054a72b96a88a241f2b09b560fa8/loguru-0.7.2.tar.gz"
    sha256 "e671a53522515f34fd406340ee968cb9ecafbc4b36c679da03c18fd8d0bd51ac"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdit-py-plugins" do
    url "https://files.pythonhosted.org/packages/00/6c/79c52651b22b64dba5c7bbabd7a294cc410bfb2353250dc8ade44d7d8ad8/mdit_py_plugins-0.4.1.tar.gz"
    sha256 "834b8ac23d1cd60cec703646ffd22ae97b7955a6d596eb1d304be1e251ae499c"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "myloginpath" do
    url "https://files.pythonhosted.org/packages/21/30/9acf030d204770c1134e130e8eb1293ce5ecd6a72046aaca68fbd76ead00/myloginpath-0.0.4.tar.gz"
    sha256 "c44b8d11e8f35a02eeac4b88bf244203c09cc496bfa19ce99a79561c038f9d09"
  end

  resource "orjson" do
    url "https://files.pythonhosted.org/packages/9e/03/821c8197d0515e46ea19439f5c5d5fd9a9889f76800613cfac947b5d7845/orjson-3.10.7.tar.gz"
    sha256 "75ef0640403f945f3a1f9f6400686560dbfb0fb5b16589ad62cd477043c4eee3"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "plotext" do
    url "https://files.pythonhosted.org/packages/27/d7/58f5ec766e41f8338f04ec47dbd3465db04fbe2a6107bca5f0670ced253a/plotext-5.2.8.tar.gz"
    sha256 "319a287baabeb8576a711995f973a2eba631c887aa6b0f33ab016f12c50ffebe"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/8e/62/8336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31/pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "pymysql" do
    url "https://files.pythonhosted.org/packages/b3/8f/ce59b5e5ed4ce8512f879ff1fa5ab699d211ae2495f1adaa5fbba2a1eada/pymysql-1.1.1.tar.gz"
    sha256 "e127611aaf2b417403c60bf4dc570124aeb4a57f5f37b8e95ae399a42f904cd0"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/b3/01/c954e134dc440ab5f96952fe52b4fdc64225530320a910473c1fe270d9aa/rich-13.7.1.tar.gz"
    sha256 "9be308cb1fe2f1f57d67ce99e95af38a1e2bc71ad9813b0e247cf7ffbcc3a432"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/8d/37/f4d4ce9bc15e61edba3179f9b0f763fc6d439474d28511b11f0d95bab7a2/setuptools-73.0.1.tar.gz"
    sha256 "d59a3e788ab7e012ab2c4baed1b376da6366883ee20d7a5fc426816e3d7b1193"
  end

  resource "sqlparse" do
    url "https://files.pythonhosted.org/packages/73/82/dfa23ec2cbed08a801deab02fe7c904bfb00765256b155941d789a338c68/sqlparse-0.5.1.tar.gz"
    sha256 "bb6b4df465655ef332548e24f08e205afc81b9ab86cb1c45657a7ff173a3a00e"
  end

  resource "textual" do
    url "https://files.pythonhosted.org/packages/44/d0/95d414ca4cdb2b2b9e4d15db1962eddc310992bd385432560189185efa83/textual-0.75.0.tar.gz"
    sha256 "1bcff456bdc00c45ae0c0c61571f113b569f67e9b68b5ece5144e4089fd780a5"
  end

  resource "textual-autocomplete" do
    url "https://files.pythonhosted.org/packages/c3/4f/6c5917fdf9bfa0c18dfd3828ac70df6b5ddee9dd3b403d774447e1c0fec5/textual_autocomplete-2.1.0b0.tar.gz"
    sha256 "ba31da6e9b77e4c35323c267f958f0b90e1c2ddeca9c825c7d6c29d4d33893ce"
  end

  resource "tree-sitter" do
    url "https://files.pythonhosted.org/packages/4a/64/71b3a0ff7d0d89cb333caeca01992099c165bdd663e7990ea723615e60f4/tree_sitter-0.20.4.tar.gz"
    sha256 "6adb123e2f3e56399bbf2359924633c882cc40ee8344885200bca0922f713be5"
  end

  # sdist issue report, https://github.com/grantjenks/py-tree-sitter-languages/issues/63
  resource "tree-sitter-languages" do
    url "https://mirror.ghproxy.com/https://github.com/grantjenks/py-tree-sitter-languages/archive/refs/tags/v1.10.2.tar.gz"
    sha256 "cdd03196ebaf8f486db004acd07a5b39679562894b47af6b20d28e4aed1a6ab5"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "uc-micro-py" do
    url "https://files.pythonhosted.org/packages/91/7a/146a99696aee0609e3712f2b44c6274566bc368dfe8375191278045186b8/uc-micro-py-1.0.3.tar.gz"
    sha256 "d321b92cff673ec58027c04015fcaa8bb1e005478643ff4a500882eaab88c48a"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/43/6d/fa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6/urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  resource "zstandard" do
    url "https://files.pythonhosted.org/packages/ed/f6/2ac0287b442160a89d726b17a9184a4c615bb5237db763791a7fd16d9df1/zstandard-0.23.0.tar.gz"
    sha256 "b2d8c62d08e7255f68f7a740bae85b3c9b8e5466baa9cbf7f57f1cde0ac6bc09"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # Fails in Linux CI with "ParseError: end of file reached"
    # See https://github.com/Homebrew/homebrew-core/pull/152912#issuecomment-1787257320
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    output = shell_output("#{bin}/dolphie mysql://user:password@host:port 2>&1")
    assert_match "Invalid URI: Port could not be cast to integer value as 'port'", output

    assert_match version.to_s, shell_output("#{bin}/dolphie --version")
  end
end
