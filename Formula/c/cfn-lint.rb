class CfnLint < Formula
  include Language::Python::Virtualenv

  desc "Validate CloudFormation templates against the CloudFormation spec"
  homepage "https://github.com/aws-cloudformation/cfn-lint/"
  url "https://files.pythonhosted.org/packages/1b/39/e47e6f08e3c3298d5fb004e2075479d0846f169c13f731944002bd510040/cfn_lint-1.4.2.tar.gz"
  sha256 "5f70df127c438117bb7f6da73e2310cebcf1901ba5ed001c6fbb0715c09efdde"
  license "MIT-0"

  livecheck do
    url :stable
    regex(/href=.*?cfn_lint[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c15e56b5f0e08088417806fe8e42ffe8506d089d85d4d724cb43c43e556405f9"
    sha256 cellar: :any,                 arm64_ventura:  "fe6fb701bcd533af7c518edb21b50072af09a71ae2f982fa4743ecead8a2e113"
    sha256 cellar: :any,                 arm64_monterey: "20d70734fa394cb3d22ff1fe56a48c64a213512c21803e00002aaecb6cf89922"
    sha256 cellar: :any,                 sonoma:         "c8db3b9e1ae4fc5eb4dcce11a67deed123c0b311c99887d73e6a8b803d786033"
    sha256 cellar: :any,                 ventura:        "421ebef2914c5a8f39711ee8c7984c76871b2a90d25e38da405341e6b9a7184f"
    sha256 cellar: :any,                 monterey:       "6274c6c2250c41dd34991267aef32befcaf94bc158a9079ae9bb4b55aa4b18ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "496523cc00921b86f471190cdfeed4b35ab0f135b92dc79b8c87c236bd7d9299"
  end

  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.12"

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/e3/fc/f800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650d/attrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "aws-sam-translator" do
    url "https://files.pythonhosted.org/packages/03/81/448cc26a70366e681eeb4ae868e1e5519f5d2d3d8602dd69731f236cbd43/aws_sam_translator-1.89.0.tar.gz"
    sha256 "fff1005d0b1f3cb511d0ac7e85f54af06afc9d9e433df013a2338d7a0168d174"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/62/0a/68b3c21e216cdbbefa7359e112366fbb9814a95f5685fe48cd645e42a11e/boto3-1.34.135.tar.gz"
    sha256 "344f635233c85dbb509b87638232ff9132739f90bb5e6bf01fa0e0a521a9107e"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/a5/5c/daf47c0a9b31c0e57652bad6b22891c9efea5272fb0d62ee5429f0fb37e8/botocore-1.34.135.tar.gz"
    sha256 "2e72f37072f75cb1391fca9d7a4c32cecb52a3557d62431d0f59d5311dc7d0cf"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/42/78/18813351fe5d63acad16aec57f94ec2b70a09e53ca98145589e185423873/jsonpatch-1.33.tar.gz"
    sha256 "9fcd4009c41e6d12348b4a0ff2563ba56a2923a7dfee731d004e212e1ee5030c"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/6a/0a/eebeb1fa92507ea94016a2a790b93c2ae41a7e18778f85471dc54475ed25/jsonpointer-3.0.0.tar.gz"
    sha256 "2b2d729f2091522d61c3b31f82e11870f60b68f43fbc705cb76bf4b832af59ef"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/19/f1/1c1dc0f6b3bf9e76f7526562d29c320fa7d6a2f35b37a1392cc0acd58263/jsonschema-4.22.0.tar.gz"
    sha256 "5b22d434a45935119af990552c862e5d6d564e8f6601206b305a61fdf661a2b7"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/f8/b9/cc0cc592e7c195fb8a650c1d5990b10175cf13b4c97465c72ec841de9e4b/jsonschema_specifications-2023.12.1.tar.gz"
    sha256 "48a76787b3e70f5ed53f1160d2b81f586e4ca6d1548c5de7085d1682674764cc"
  end

  resource "mpmath" do
    url "https://files.pythonhosted.org/packages/e0/47/dd32fa426cc72114383ac549964eecb20ecfd886d1e5ccf5340b55b02f57/mpmath-1.3.0.tar.gz"
    sha256 "7a28eb2a9774d00c7bc92411c19a89209d5da7c4c9a9e227be8330a23a25b91f"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/04/e6/b164f94c869d6b2c605b5128b7b0cfe912795a87fc90e78533920001f3ec/networkx-3.3.tar.gz"
    sha256 "0c127d8b2f4865f59ae9cb8aafcd60b5c70f3241ebd66f7defad7c4ab90126c9"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/0d/fc/ccd0e8910bc780f1a4e1ab15e97accbb1f214932e796cff3131f9a943967/pydantic-2.7.4.tar.gz"
    sha256 "0c84efd9548d545f63ac0060c1e4d39bb9b14db8b3c0652338aecc07b5adec52"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/02/d0/622cdfe12fb138d035636f854eb9dc414f7e19340be395799de87c1de6f6/pydantic_core-2.18.4.tar.gz"
    sha256 "ec3beeada09ff865c344ff3bc2f427f5e6c26401cc6113d77e372c3fdac73864"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/99/5b/73ca1f8e72fff6fa52119dbd185f73a907b1989428917b24cff660129b6d/referencing-0.35.1.tar.gz"
    sha256 "25b42124a6c8b632a425174f24087783efb348a6f1e0008e63cd4466fedf703c"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/7a/db/5ddc89851e9cc003929c3b08b9b88b429459bf9acbf307b4556d51d9e49b/regex-2024.5.15.tar.gz"
    sha256 "d3ee02d9e5f482cc8309134a91eeaacbdd2261ba111b0fef3748eeb4913e6a2c"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/2d/aa/e7c404bdee1db7be09860dff423d022ffdce9269ec8e6532cce09ee7beea/rpds_py-0.18.1.tar.gz"
    sha256 "dc48b479d540770c811fbd1eb9ba2bb66951863e448efec2e2c102625328e92f"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/cb/67/94c6730ee4c34505b14d94040e2f31edf144c230b6b49e971b4f25ff8fab/s3transfer-0.10.2.tar.gz"
    sha256 "0711534e9356d3cc692fdde846b4a1e4b0cb6519971860796e6bc4c7aea00ef6"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "sympy" do
    url "https://files.pythonhosted.org/packages/41/8a/0d1bbd33cd3091c913d298746e56f40586fa954788f51b816c6336424675/sympy-1.12.1.tar.gz"
    sha256 "2877b03f998cd8c08f07cd0de5b767119cd3ef40d09f41c30d722f6686b0fb88"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/43/6d/fa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6/urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.yml").write <<~EOS
      ---
      AWSTemplateFormatVersion: '2010-09-09'
      Resources:
        # Helps tests map resource types
        IamPipeline:
          Type: "AWS::CloudFormation::Stack"
          Properties:
            TemplateURL: !Sub 'https://s3.${AWS::Region}.amazonaws.com/bucket-dne-${AWS::Region}/${AWS::AccountId}/pipeline.yaml'
            Parameters:
              DeploymentName: iam-pipeline
              Deploy: 'auto'
    EOS
    system bin/"cfn-lint", "test.yml"
  end
end
