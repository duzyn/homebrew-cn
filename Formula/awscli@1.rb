class AwscliAT1 < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  # awscli should only be updated every 10 releases on multiples of 10
  url "https://files.pythonhosted.org/packages/87/d7/89985927c4d8cc43a541ebeac5e90de70d36a46843a0cb9fd4a59b8a835d/awscli-1.27.40.tar.gz"
  sha256 "c4ffae81aa62e8a244f94a2418a986ebbcdee5d1fa9c9b8993b06322be9db531"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/aws/aws-cli.git"
    regex(/^v?(1(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "05dbd238a1d2f8fe801f23f8a11b67055ebc2a616a67e9d33af6d5adc725d8a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c12208bc5492eefbd377d5d6de728fb26f6fb0efc3096d66d0acc46285a7c18"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f830b5c46a5a8a6d9b6c891e1958b32ba8a3169f963cd11f92d96b4e87e915a"
    sha256 cellar: :any_skip_relocation, ventura:        "876c603ffba4819c262607ec834b45adf798a69635eb82568015940e63f35037"
    sha256 cellar: :any_skip_relocation, monterey:       "a4cbb86b21481de2b0fe2757215d2eb866942d3d4dd39aac47d4c562ba9361b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "5dcd3f9fc78a5590471e9b495b2abc70e273107fd6665f52c8c4c4414bc00e76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa16c72bde742b9834b726648902fae06c3b8144f188d0d07f82d49cc26052cf"
  end

  keg_only :versioned_formula

  depends_on "docutils"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  # Remove this dependency when the version is at or above 1.27.6
  # and replace with `uses_from_macos "mandoc"`
  on_system :linux, macos: :ventura_or_newer do
    depends_on "groff"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/15/14/b7c79524e8cc07dff7d3c040be652950d017da7da7ddcdd022e998b5373b/botocore-1.29.40.tar.gz"
    sha256 "e582ac0729018da415b0b5de14ea31ffd0ad0483a9fdb8147902526d06347fb7"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/a4/db/fffec68299e6d7bad3d504147f9094830b704527a7fc098b721d38cc7fa7/pyasn1-0.4.8.tar.gz"
    sha256 "aef77c9fb94a3ac588e87841208bdec464471d9871bd5050a287cc9a475cd0ba"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/db/b5/475c45a58650b0580421746504b680cd2db4e81bc941e94ca53785250269/rsa-4.7.2.tar.gz"
    sha256 "9d689e6ca1b3038bc82bf8d23e944b6b6037bc02301a574935b2dd946e0353b9"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/e1/eb/e57c93d5cd5edf8c1d124c831ef916601540db70acd96fa21fe60cef1365/s3transfer-0.6.0.tar.gz"
    sha256 "2ed07d3866f523cc561bf4a00fc5535827981b117dd7876f036b0c1aca42c947"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c2/51/32da03cf19d17d46cce5c731967bf58de9bd71db3a379932f53b094deda4/urllib3-1.26.13.tar.gz"
    sha256 "c083dd0dce68dbfbe1129d5271cb90f9447dea7d52097c6e0126120c521ddea8"
  end

  def install
    virtualenv_install_with_resources
    pkgshare.install "awscli/examples"

    rm Dir["#{bin}/{aws.cmd,aws_bash_completer,aws_zsh_completer.sh}"]
    bash_completion.install "bin/aws_bash_completer"
    zsh_completion.install "bin/aws_zsh_completer.sh"
    (zsh_completion/"_aws").write <<~EOS
      #compdef aws
      _aws () {
        local e
        e=$(dirname ${funcsourcetrace[1]%:*})/aws_zsh_completer.sh
        if [[ -f $e ]]; then source $e; fi
      }
    EOS
  end

  def caveats
    <<~EOS
      The "examples" directory has been installed to:
        #{HOMEBREW_PREFIX}/share/awscli/examples
    EOS
  end

  test do
    assert_match "topics", shell_output("#{bin}/aws help")
  end
end
