class AnsibleLint < Formula
  include Language::Python::Virtualenv

  desc "Checks ansible playbooks for practices and behaviour"
  homepage "https://github.com/ansible/ansible-lint/"
  url "https://files.pythonhosted.org/packages/eb/c7/93776a1c44fe66dc95867d636abee201144920b34633f6aa115f43680889/ansible-lint-6.10.1.tar.gz"
  sha256 "24f15b61af52bc22b05d008f9eb7662f1cf42ab74008da9f89af71fc540ccfa4"
  license all_of: ["MIT", "GPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5676082843b825370c299fc8734374f7391716f35d1629d21bc662d26a48607f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51477ac26b253605665956b4b6c50db52e4dda9a70b7edd4946dced1f42093fe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d528d8111df20432ea4bb8d1cc8c6f6db43ef5e0ed58ee27e5e3b2d78716527c"
    sha256 cellar: :any_skip_relocation, ventura:        "48935530f81e281bacbf68f9857348687e763e46dbc88081c3602c34d0e11be0"
    sha256 cellar: :any_skip_relocation, monterey:       "2f8dab21768fdb4fc89ad974defcabfadf0b64f907e4b71a01ee5f7225a4a781"
    sha256 cellar: :any_skip_relocation, big_sur:        "87faf9fb1ebfad6e936a6fd6a46af4ee0093cd7baa2103cf95a2cf536ffbe3e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8550e4177a7ee1cb4962ead2c272b3d72f97aa43a6222a77841634f878488516"
  end

  depends_on "pkg-config" => :build
  depends_on "ansible"
  depends_on "black"
  depends_on "pygments"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "yamllint"

  resource "ansible-compat" do
    url "https://files.pythonhosted.org/packages/b6/a1/bf63af6f20afa76b828956e67b811e76615cb06cbd44f5be1ff8cadb902a/ansible-compat-2.2.7.tar.gz"
    sha256 "08deddcd0a1dc6baabe674b07c6ff882118492c123d281f56f01905271a7ffc4"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/21/31/3f468da74c7de4fcf9b25591e682856389b3400b4b62f201e65f15ea3e07/attrs-22.2.0.tar.gz"
    sha256 "c9227bfc2f01993c03f68db37d1d15c9690188323c067c641f1a35ca58185f99"
  end

  resource "bracex" do
    url "https://files.pythonhosted.org/packages/b3/96/d53e290ddf6215cfb24f93449a1835eff566f79a1f332cf046a978df0c9e/bracex-2.3.post1.tar.gz"
    sha256 "e7b23fc8b2cd06d3dec0692baabecb249dda94e06a617901ff03a6c56fd71693"
  end

  resource "commonmark" do
    url "https://files.pythonhosted.org/packages/60/48/a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0/commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/0b/dc/eac02350f06c6ed78a655ceb04047df01b02c6b7ea3fc02d4df24ca87d24/filelock-3.9.0.tar.gz"
    sha256 "7b319f24340b51f55a2bf7a12ac0755a9b03e718311dac567a0f4f7fabd2f5de"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/36/3d/ca032d5ac064dff543aa13c984737795ac81abc9fb130cd2fcff17cfabc7/jsonschema-4.17.3.tar.gz"
    sha256 "0f864437ab8b6076ba6707453ef8f98a6a0d512a80e93f8abdb676f737ecb60d"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/6b/f7/c240d7654ddd2d2f3f328d8468d4f1f876865f6b9038b146bec0a6737c65/packaging-22.0.tar.gz"
    sha256 "2198ec20bd4c017b8f9717e00f0c8714076fc2fd93816750ab48e2c41de2cfd3"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/bf/90/445a7dbd275c654c268f47fa9452152709134f61f09605cf776407055a89/pyrsistent-0.19.3.tar.gz"
    sha256 "1a2994773706bbb4995c31a97bc94f1418314923bd1048c6d964837040376440"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/b4/b9/f735d18e35aea71b6516d2970d268fccf3978f4848156ed20cc858c287bd/rich-13.0.0.tar.gz"
    sha256 "3aa9eba7219b8c575c6494446a59f702552efe1aa261e7eeb95548fa586e1950"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/46/a9/6ed24832095b692a8cecc323230ce2ec3480015fbfa4b79941bd41b23a3c/ruamel.yaml-0.17.21.tar.gz"
    sha256 "8b7ce697a2f212752a35c1ac414471dc16c424c9573be4926b56ff3f5d23b7af"
  end

  resource "subprocess-tee" do
    url "https://files.pythonhosted.org/packages/f6/a0/acafd85c7c0aead293a16a70a49aba20ba2af9478771370b2897eae6059c/subprocess-tee-0.4.1.tar.gz"
    sha256 "b3c124993f8b88d1eb1c2fde0bc2069787eac720ba88771cba17e8c93324825d"
  end

  resource "wcmatch" do
    url "https://files.pythonhosted.org/packages/b7/94/5dd083fc972655f6689587c3af705aabc8b8e781bacdf22d6d2282fe6142/wcmatch-8.4.1.tar.gz"
    sha256 "b1f042a899ea4c458b7321da1b5e3331e3e0ec781583434de1301946ceadb943"
  end

  def install
    virtualenv_install_with_resources

    site_packages = Language::Python.site_packages("python3.11")
    %w[ansible black yamllint].each do |package_name|
      package = Formula[package_name].opt_libexec
      (libexec/site_packages/"homebrew-#{package_name}.pth").write package/site_packages
    end
  end

  test do
    ENV["ANSIBLE_REMOTE_TEMP"] = testpath/"tmp"
    (testpath/"playbook.yml").write <<~EOS
      ---
      - hosts: all
        gather_facts: false
        tasks:
        - name: ping
          ansible.builtin.ping:
    EOS
    system bin/"ansible-lint", testpath/"playbook.yml"
  end
end
