class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://github.com/PyCQA/pylint"
  url "https://files.pythonhosted.org/packages/1e/fa/690c4dcf3ade9ae0497413c788267eafa36228394099708bb0fd0b8a6949/pylint-2.15.8.tar.gz"
  sha256 "ec4a87c33da054ab86a6c79afa6771dc8765cb5631620053e727fcf3ef8cbed7"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2606e39ccc345e730370dbc9af9c7984eb2361539235078ab7b48010d0f5fbe1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "290b59456402f93ee98408143cc4905c7648fd38fab2a1adefced826cb8e3f31"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cd79ec19e5c92b1edd55b1b20bc2fcacc963fc314d684759f9b04c930f3f7cbe"
    sha256 cellar: :any_skip_relocation, ventura:        "1be2c0e6790064f9238ac510d8787aed25efffd2bb8bf7d1af4625249ddf80df"
    sha256 cellar: :any_skip_relocation, monterey:       "73bb1b8f64072b56497871f9e4942b89cab8fa2c585e2399cce2009943354a68"
    sha256 cellar: :any_skip_relocation, big_sur:        "39b25268af11f0b664086ebf50f2c29d72a3652433e7a6d5b1bd1b64a9b05878"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d235df914d009eb994a3192e2ecb89353aa101e3d27ac7fda9fae68a1a7f7ad3"
  end

  depends_on "isort"
  depends_on "python@3.11"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/61/d0/e7cfca72ec7d6c5e0da725c003db99bb056e9b6c2f4ee6fae1145adf28a6/astroid-2.12.13.tar.gz"
    sha256 "1493fe8bd3dfd73dc35bd53c9d5b6e49ead98497c47b2307662556a5692d29d7"
  end

  resource "dill" do
    url "https://files.pythonhosted.org/packages/7c/e7/364a09134e1062d4d5ff69b853a56cf61c223e0afcc6906b6832bcd51ea8/dill-0.3.6.tar.gz"
    sha256 "e5db55f3687856d8fbdab002ed78544e1c4559a130302693d839dfe8f93f2373"
  end

  resource "lazy-object-proxy" do
    url "https://files.pythonhosted.org/packages/74/37/591f89e8a09ae4574391bdf8a5eecd34a3dbe545917333e625c9de9a66b0/lazy-object-proxy-1.8.0.tar.gz"
    sha256 "c219a00245af0f6fa4e95901ed28044544f50152840c5b6a3e7b2568db34d156"
  end

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/e7/ff/0ffefdcac38932a54d2b5eed4e0ba8a408f215002cd178ad1df0f2806ff8/mccabe-0.7.0.tar.gz"
    sha256 "348e0240c33b60bbdf4e523192ef919f28cb2c3d7d5c7794f74009290f236325"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/cb/5f/dda8451435f17ed8043eab5ffe04e47d703debe8fe845eb074f42260e50a/platformdirs-2.5.4.tar.gz"
    sha256 "1006647646d80f16130f052404c6b901e80ee4ed6bef6792e1f238a8969106f7"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/ff/04/58b4c11430ed4b7b8f1723a5e4f20929d59361e9b17f0872d69681fd8ffd/tomlkit-0.11.6.tar.gz"
    sha256 "71b952e5721688937fb02cf9d354dbcf0785066149d2855e44531ebdd2b65d73"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/11/eb/e06e77394d6cf09977d92bff310cb0392930c08a338f99af6066a5a98f92/wrapt-1.14.1.tar.gz"
    sha256 "380a85cf89e0e69b7cfbe2ea9f765f004ff419f34194018a6827ac0e3edfed4d"
  end

  def install
    virtualenv_install_with_resources

    # we depend on isort, but that's a separate formula, so install a `.pth` file to link them
    site_packages = Language::Python.site_packages("python3.11")
    isort = Formula["isort"].opt_libexec
    (libexec/site_packages/"homebrew-isort.pth").write isort/site_packages
  end

  test do
    (testpath/"pylint_test.py").write <<~EOS
      print('Test file'
      )
    EOS
    system bin/"pylint", "--exit-zero", "pylint_test.py"
  end
end
