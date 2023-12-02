class Pipx < Formula
  include Language::Python::Virtualenv

  desc "Execute binaries from Python packages in isolated environments"
  homepage "https://pypa.github.io/pipx"
  url "https://files.pythonhosted.org/packages/da/1b/5ebbf68e321684ffca2ee6757c4f6962a136e75a4925554f774f511666ad/pipx-1.3.0.tar.gz"
  sha256 "db07ec2a3a15d772a71b2608c134f065d7fbc51d4654abe6adfc412800ed6ba4"
  license "MIT"
  head "https://github.com/pypa/pipx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8f0ff71980a043221939efaeb6bd1ea6adbaaa35e39b1fd5999d35ad760a2113"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bfa1565ab1a7d8a31ed989c90bd3e109f8639fcb636f9ba38a2df96215ad6932"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c48bdf708348bbebe7cda3617c123b4d611b423af4fef497d083755a5cbae03"
    sha256 cellar: :any_skip_relocation, sonoma:         "e965f3734bceffb9beae2f70129b906f6b940594fcaf02210878942b0a65d239"
    sha256 cellar: :any_skip_relocation, ventura:        "6f315f5e229c97f8f00594cf6ff76c9765cdfd9f54aa919dcfec863c65740db4"
    sha256 cellar: :any_skip_relocation, monterey:       "0b23ac18cf62e5c74d8a5a3f36071369309b9b0ef4682846bb78243256665b9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb58d051eb6c40efbc41400b4f1762f018bc848138c052f13c9f40a0c6ed4f47"
  end

  depends_on "python-argcomplete"
  depends_on "python-packaging"
  depends_on "python@3.12"

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/31/28/e40d24d2e2eb23135f8533ad33d582359c7825623b1e022f9d460def7c05/platformdirs-4.0.0.tar.gz"
    sha256 "cb633b2bcf10c51af60beb0ab06d2f1d69064b43abf4c185ca6b28865f3f9731"
  end

  resource "userpath" do
    url "https://files.pythonhosted.org/packages/4d/13/b8c47191994abd86cbdb256146dbd7bbabcaaa991984b720f68ccc857bfc/userpath-1.9.1.tar.gz"
    sha256 "ce8176728d98c914b6401781bf3b23fccd968d1647539c8788c7010375e02796"
  end

  def python3
    deps.map(&:to_formula)
        .find { |f| f.name.start_with?("python@") }
  end

  def install
    # Avoid Cellar path reference, which is only good for one version.
    inreplace "src/pipx/interpreter.py",
              "DEFAULT_PYTHON = _get_sys_executable()",
              "DEFAULT_PYTHON = '#{python3.opt_libexec/"bin/python"}'"

    virtualenv_install_with_resources

    register_argcomplete = Formula["python-argcomplete"].opt_bin/"register-python-argcomplete"
    generate_completions_from_executable(register_argcomplete, "pipx", shell_parameter_format: :arg)
  end

  test do
    assert_match "PIPX_HOME", shell_output("#{bin}/pipx --help")
    system bin/"pipx", "install", "csvkit"
    assert_predicate testpath/".local/bin/csvjoin", :exist?
    system bin/"pipx", "uninstall", "csvkit"
    refute_match "csvjoin", shell_output("#{bin}/pipx list")
  end
end
