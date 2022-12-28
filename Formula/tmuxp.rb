class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/f4/f2/caa86fe8ab4d2340a92c40150649a37d15a28dc2016edefc110432cdb977/tmuxp-1.22.0.tar.gz"
  sha256 "ea6f3f88a58d4c33217d677414849b5a42ce698e0443bcfa4963e6785529b16c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "691ac38ca9692698bad61fce3373bc4b24b05153d0142373abb8b55ccbd652e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37b85874b8bc8df657cc565f374ab620082e807649f536bb31518d1e9ac0ac7a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1987ae2ea42aeb4d8a322f47c933eed82c8f4f9a8e5020ff8bbaf546cae65dd3"
    sha256 cellar: :any_skip_relocation, ventura:        "82086d6de4032e5c900cdf5efbaca5db23c2fef92d7d3ebf3419efd96946ace0"
    sha256 cellar: :any_skip_relocation, monterey:       "4242455226339cbb7b599149b3ef1b2beb43667ed8cfa0f5c442d16b69a5a970"
    sha256 cellar: :any_skip_relocation, big_sur:        "0db303cb737cabb7f65ffa317d05a649d508f05b797388616b0210751a62da40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c46a00501512603d9f4c31c3c3f0dbdbe5abede75fd9fae42a53f18a58a5d86f"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/db/88/d42e629a52be35ff4774d8f154bfe1c263ab2ee37f069fa792f0423bf530/libtmux-0.18.0.tar.gz"
    sha256 "c51ccd5ef5ff18232fd56a72cadddd36bf3ad79e0dbd34cdad4a06d821a2af84"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tmuxp --version")

    (testpath/"test_session.yaml").write <<~EOS
      session_name: 2-pane-vertical
      windows:
      - window_name: my test window
        panes:
          - echo hello
          - echo hello
    EOS

    system bin/"tmuxp", "debug-info"
    system bin/"tmuxp", "convert", "--yes", "test_session.yaml"
    assert_predicate testpath/"test_session.json", :exist?
  end
end
