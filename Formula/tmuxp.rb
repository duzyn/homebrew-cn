class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/68/39/1b82064180d75a1f739dd962c95d665757c90a2faa6c4f476c49c3a16f96/tmuxp-1.25.0.tar.gz"
  sha256 "f36bee4938fc42bcd621d91c8b7333c8454480a95f6ad6064850cecd5af01387"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "986b24efc13dc7be2c5d0e15e0db98b8bc981f95ade5e0831cb2b2d7460c6b32"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "869a668a1ea3d1e1a39a692a34040f5beae87a2571592893b745c30f3d671287"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "66455cee58830da0cdfd3a8530ff45ec277d52a5c5d2d73bb99ba4f8c138d32b"
    sha256 cellar: :any_skip_relocation, ventura:        "03b14710e9bc2c8c5778114e36e283654de233fac6f827e897a1128326d0b15d"
    sha256 cellar: :any_skip_relocation, monterey:       "ca6c605278c767b2b25f3ec06334d0707f5dd074a1c599370768ee325ef404ca"
    sha256 cellar: :any_skip_relocation, big_sur:        "04b21d61c6e81fdc6777c51769f1469b7329ae02f9286486c392687229997c05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a6a633787a8633ed1f1e635adf28fe6664f53113b31f40bde06a5ffbdf65f30"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/02/98/3d5bb96dca3c8e2bb6a541a7b90821e2bade1457948b9c99b7a15de528a7/libtmux-0.19.1.tar.gz"
    sha256 "614fea2b09ed344735b4da2fe35e763ca2087e89a73c39d3663ed7f515fae356"
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
