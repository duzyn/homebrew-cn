class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/df/7c/f4fd1b0b25d98d9a038b0d993d1a8f2496037e793ca16d912cc44c7b1827/tmuxp-1.19.1.tar.gz"
  sha256 "b7f0d1ead5f100c157f44ff8c6193670d30ab6e7fc3f008160ed93f7d4e8fe33"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ebc46de41f0d0c328dcccb5b8db82bec2c2f261c1150f9458ac7b1691a7fb62c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2290fba7f4016b16bbb3048b94812bdcbce77c3707741f256aab5a0a7458a64c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "18609d6a41795cdad37e5aa46ef771f48b80de3d806f5c6aaaf3b3145f1e940b"
    sha256 cellar: :any_skip_relocation, ventura:        "2357163d075a87356cfd3f8c57f0189340439dcb4f27c203895919e3d8c76d2f"
    sha256 cellar: :any_skip_relocation, monterey:       "c6170bcc20f8d09600a4f9231ae87385ed03022e52ff2724219bf693dde8ebbd"
    sha256 cellar: :any_skip_relocation, big_sur:        "67ef8e7e9319b832c12b7019304c5584629ed466d70c6496bc878ff05e709c8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89682a921b13af82d9a5f634567f3a2281e659c9e269c270db761a8a7a553436"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/91/e3/0b2a2a56b9437385f1270cfd1a2c7c07fcb6d9f01f186b8431bcdda951ed/libtmux-0.16.1.tar.gz"
    sha256 "4b5b74e70e0edf2e7a5c1a841fffcd78e1f203205ced9c9b0dd325a6d903d0ed"
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
