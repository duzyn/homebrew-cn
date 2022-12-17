class CfnLint < Formula
  include Language::Python::Virtualenv

  desc "Validate CloudFormation templates against the CloudFormation spec"
  homepage "https://github.com/aws-cloudformation/cfn-lint/"
  url "https://files.pythonhosted.org/packages/9f/97/a8a2c7242ee5ae81469d8e0e4704ed3a572ee69f8147750f6672c6a2afc8/cfn-lint-0.72.4.tar.gz"
  sha256 "71cfffa1d3f1ceff7973b28eaa5a22e786186465658f42ed3874ed413b168d58"
  license "MIT-0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "653124672fd0dc4f52c12b6ada1e3707af443e94d2ebb8f049edce837f4e6e92"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a568a7ab0038a4ee6997aa3a8e45c1707beabcda6b83e910f8c1f5225fce5548"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "35ee37f522aad6d5456bd9c2144a3449f9af2959ef74a17a20a68f519e955a4a"
    sha256 cellar: :any_skip_relocation, ventura:        "e4d9c754009669f869b67533172dff549140abc9d4715d0a7495b60f59fa2d19"
    sha256 cellar: :any_skip_relocation, monterey:       "d6dd1cfa044c36b332a8f2eeed9d8c045e1fe0fbc870d66c46f583ecb44fb173"
    sha256 cellar: :any_skip_relocation, big_sur:        "1f18785d459eea0edbc24b3a2afb654af66ade510206fa72b391b14f5d9c325c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0d0980bda9d54a8a8b39d11c0b96b10e555c3607c68e67ed11defd1e58c0949"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/1a/cb/c4ffeb41e7137b23755a45e1bfec9cbb76ecf51874c6f1d113984ecaa32c/attrs-22.1.0.tar.gz"
    sha256 "29adc2665447e5191d0e7c568fde78b21f9672d344281d0c6e1ab085429b22b6"
  end

  resource "aws-sam-translator" do
    url "https://files.pythonhosted.org/packages/c2/b7/df9463df4ebf3d573a58accc394fe3b5c765e49d3502d3175dc449519178/aws-sam-translator-1.55.0.tar.gz"
    sha256 "08e182e76d6fabc13ce2f38b8a3932b3131407c6ad29ec2849ef3d9a41576b94"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/37/ba/0c307fd20bc3022c4d6df2059535a004af296c6c31ed1ecaf2d8fd841475/boto3-1.26.31.tar.gz"
    sha256 "5a37503ad456a6beae2740d2367c0a514b07ef0e134cdcc2b77cc8481832751b"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/f0/66/865a2e8806df3933945ef2d7bdf22125a871d539a82553484604c1aa4de2/botocore-1.29.31.tar.gz"
    sha256 "2ef360b7323f94128943a40297e457832384141577ded0b807e6d6a794fba636"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "jschema-to-python" do
    url "https://files.pythonhosted.org/packages/1d/7f/5ae3d97ddd86ec33323231d68453afd504041efcfd4f4dde993196606849/jschema_to_python-1.2.3.tar.gz"
    sha256 "76ff14fe5d304708ccad1284e4b11f96a658949a31ee7faed9e0995279549b91"
  end

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/21/67/83452af2a6db7c4596d1e2ecaa841b9a900980103013b867f2865e5e1cf0/jsonpatch-1.32.tar.gz"
    sha256 "b6ddfe6c3db30d81a96aaeceb6baf916094ffa23d7dd5fa2c13e13f8b6e600c2"
  end

  resource "jsonpickle" do
    url "https://files.pythonhosted.org/packages/d8/56/4351ac08ac5bf7207d6c1f6cfb327ed9599c452ced03ab165810bc87e471/jsonpickle-3.0.0.tar.gz"
    sha256 "504586e5c0fd52fd76a56f86c36f8c4d29778bdef92dc06d38ca6e2e9fc4f090"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/a0/6c/c52556b957a0f904e7c45585444feef206fe5cb1ff656303a1d6d922a53b/jsonpointer-2.3.tar.gz"
    sha256 "97cba51526c829282218feb99dab1b1e6bdf8efd1c43dc9d57be093c0d69c99a"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/69/11/a69e2a3c01b324a77d3a7c0570faa372e8448b666300c4117a516f8b1212/jsonschema-3.2.0.tar.gz"
    sha256 "c8a85b28d377cc7737e46e2d9f2b4f44ee3c0e1deac6bf46ddefc7187d30797a"
  end

  # only doing this because junit-xml source is not available in PyPI for v1.9
  resource "junit-xml" do
    url "https://github.com/kyrus/python-junit-xml.git",
        revision: "4bd08a272f059998cedf9b7779f944d49eba13a6"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/cd/16/c44e8550012735b8f21b3df7f39e8ba5a987fb764ac017ad5f3589735889/networkx-2.8.8.tar.gz"
    sha256 "230d388117af870fce5647a3c52401fcf753e94720e6ea6b4197a5355648885e"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/52/fb/630d52aaca8fc7634a0711b6ae12a0e828b6f9264bd8051225025c3ed075/pbr-5.11.0.tar.gz"
    sha256 "b97bc6695b2aff02144133c2e7399d5885223d42b7912ffaec2ca3898e673bfe"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/b8/ef/325da441a385a8a931b3eeb70db23cb52da42799691988d8d943c5237f10/pyrsistent-0.19.2.tar.gz"
    sha256 "bfa0351be89c9fcbcb8c9879b826f4353be10f58f8a677efab0c017bf7137ec2"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/e1/eb/e57c93d5cd5edf8c1d124c831ef916601540db70acd96fa21fe60cef1365/s3transfer-0.6.0.tar.gz"
    sha256 "2ed07d3866f523cc561bf4a00fc5535827981b117dd7876f036b0c1aca42c947"
  end

  resource "sarif-om" do
    url "https://files.pythonhosted.org/packages/ba/de/bbdd93fe456d4011500784657c5e4a31e3f4fcbb276255d4db1213aed78c/sarif_om-1.0.4.tar.gz"
    sha256 "cd5f416b3083e00d402a92e449a7ff67af46f11241073eea0461802a3b5aef98"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c2/51/32da03cf19d17d46cce5c731967bf58de9bd71db3a379932f53b094deda4/urllib3-1.26.13.tar.gz"
    sha256 "c083dd0dce68dbfbe1129d5271cb90f9447dea7d52097c6e0126120c521ddea8"
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
