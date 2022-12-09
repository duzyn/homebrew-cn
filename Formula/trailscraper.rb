class Trailscraper < Formula
  include Language::Python::Virtualenv

  desc "Tool to get valuable information out of AWS CloudTrail"
  homepage "https://github.com/flosell/trailscraper"
  url "https://files.pythonhosted.org/packages/b5/d0/c46ca8b3857576debced3e52471693b5acae996882c9f33a78dc6ddc91da/trailscraper-0.8.0.tar.gz"
  sha256 "b0ae6be8013226943a6db068420fef8c537c0061cb1e36528b05896aa9326393"
  license "Apache-2.0"
  head "https://github.com/flosell/trailscraper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0bb654d437d44d9d59769a77b5c2d603d1cf54660a72632935f4498acfa336cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "010aeca289d9ccc086eba0bb417b82ff593ad59b71a46f363720724e0b3b5620"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7583d820887dbe67efcf9ee53f4b30f32b4392789348870f2e6c8d47b35edf6b"
    sha256 cellar: :any_skip_relocation, ventura:        "fb760de33c8b333c2b6020284eaacf38523eb8ad00bf179142bdda9f2c4dca41"
    sha256 cellar: :any_skip_relocation, monterey:       "84170df9025d6ac407dae454486e803cbec770bcf4a8bbe58dca75b9482fb8db"
    sha256 cellar: :any_skip_relocation, big_sur:        "209de4cd23a327251538d17b5bfaa34ac56eac59429ee3c1ede333c88614528f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9588284863f7f8a4a26961d3427909011a81166546c18b1a8e346998abd3ca5"
  end

  depends_on "python@3.11"
  depends_on "six"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/bf/05/c256c7936520cc265f7561b5180920e986321916d341e7399fc5de5bea6b/boto3-1.26.22.tar.gz"
    sha256 "f16c3aef1432c5083a9e1c36ac08b70b9072e87205e970f8d7520b10b964858f"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/70/99/823369588a62d5208628d67a9488905a637989ce09d150108c9de11d6b50/botocore-1.29.24.tar.gz"
    sha256 "4f9c92979b29132185f645f61bdf0fecf031ecc26a8dd1a99dbd88d323211325"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "dateparser" do
    url "https://files.pythonhosted.org/packages/57/a0/60fd5e9e5a9d5086d124071c748214766e04d75098d892998778b02fc89f/dateparser-1.1.4.tar.gz"
    sha256 "73ec6e44a133c54076ecf9f9dc0fbe3dd4831f154f977ff06f53114d57c5425e"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/76/63/1be349ff0a44e4795d9712cc0b2d806f5e063d4d34631b71b832fac715a8/pytz-2022.6.tar.gz"
    sha256 "e89512406b793ca39f5971bc999cc538ce125c0e51c27941bef4568b460095e2"
  end

  resource "pytz-deprecation-shim" do
    url "https://files.pythonhosted.org/packages/94/f0/909f94fea74759654390a3e1a9e4e185b6cd9aa810e533e3586f39da3097/pytz_deprecation_shim-0.1.0.post0.tar.gz"
    sha256 "af097bae1b616dde5c5744441e2ddc69e74dfdcb0c263129610d85b87445a59d"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/27/b5/92d404279fd5f4f0a17235211bb0f5ae7a0d9afb7f439086ec247441ed28/regex-2022.10.31.tar.gz"
    sha256 "a3a98921da9a1bf8457aeee6a551948a83601689e5ecdd736894ea9bbec77e83"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/46/a9/6ed24832095b692a8cecc323230ce2ec3480015fbfa4b79941bd41b23a3c/ruamel.yaml-0.17.21.tar.gz"
    sha256 "8b7ce697a2f212752a35c1ac414471dc16c424c9573be4926b56ff3f5d23b7af"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/e1/eb/e57c93d5cd5edf8c1d124c831ef916601540db70acd96fa21fe60cef1365/s3transfer-0.6.0.tar.gz"
    sha256 "2ed07d3866f523cc561bf4a00fc5535827981b117dd7876f036b0c1aca42c947"
  end

  resource "toolz" do
    url "https://files.pythonhosted.org/packages/cf/05/2008534bbaa716b46a2d795d7b54b999d0f7638fbb9ed0b6e87bfa934f84/toolz-0.12.0.tar.gz"
    sha256 "88c570861c440ee3f2f6037c4654613228ff40c93a6c25e0eba70d17282c6194"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/5b/30/b7abfb11be6642d26de1c1840d25e8d90333513350ad0ebc03101d55e13b/tzdata-2022.7.tar.gz"
    sha256 "fe5f866eddd8b96e9fcba978f8e503c909b19ea7efda11e52e39494bad3a7bfa"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/7d/b9/164d5f510e0547ae92280d0ca4a90407a15625901afbb9f57a19d9acd9eb/tzlocal-4.2.tar.gz"
    sha256 "ee5842fa3a795f023514ac2d801c4a81d1743bbe642e3940143326b3a00addd7"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c2/51/32da03cf19d17d46cce5c731967bf58de9bd71db3a379932f53b094deda4/urllib3-1.26.13.tar.gz"
    sha256 "c083dd0dce68dbfbe1129d5271cb90f9447dea7d52097c6e0126120c521ddea8"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/trailscraper --version")

    test_input = '{"Records": []}'
    output = pipe_output("#{bin}/trailscraper generate", test_input)
    assert_match "Statement", output
  end
end
