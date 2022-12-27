class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "https://pre-commit.com/"
  url "https://files.pythonhosted.org/packages/6b/00/1637ae945c6e10838ef5c41965f1c864e59301811bb203e979f335608e7c/pre_commit-2.21.0.tar.gz"
  sha256 "31ef31af7e474a8d8995027fefdfcf509b5c913ff31f2015b4ec4beb26a6f658"
  license "MIT"
  head "https://github.com/pre-commit/pre-commit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f263ff1b1689dbf474b10b6ba7a3177ff93d23d941dd3a02ff4435298cc6bd0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f263ff1b1689dbf474b10b6ba7a3177ff93d23d941dd3a02ff4435298cc6bd0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6f263ff1b1689dbf474b10b6ba7a3177ff93d23d941dd3a02ff4435298cc6bd0"
    sha256 cellar: :any_skip_relocation, ventura:        "dba52d85b254022a7c38b0da6b4ebdb2c80f247f4bde35cbcc94c2c33e858dca"
    sha256 cellar: :any_skip_relocation, monterey:       "dba52d85b254022a7c38b0da6b4ebdb2c80f247f4bde35cbcc94c2c33e858dca"
    sha256 cellar: :any_skip_relocation, big_sur:        "dba52d85b254022a7c38b0da6b4ebdb2c80f247f4bde35cbcc94c2c33e858dca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7d3dc2b1f79bedf6c2e2bd784db8771a2d3443d14cf28bbcc683d24e7b10b22"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"
  depends_on "virtualenv"

  resource "cfgv" do
    url "https://files.pythonhosted.org/packages/c4/bf/d0d622b660d414a47dc7f0d303791a627663f554345b21250e39e7acb48b/cfgv-3.3.1.tar.gz"
    sha256 "f5a830efb9ce7a445376bb66ec94c638a9787422f96264c98edc6bdeed8ab736"
  end

  resource "identify" do
    url "https://files.pythonhosted.org/packages/dd/56/6ca55bade234d1eb36f09310021169385025b74c8f1fb637a4bcb2dcf3da/identify-2.5.11.tar.gz"
    sha256 "14b7076b29c99b1b0b8b08e96d448c7b877a9b07683cd8cfda2ea06af85ffa1c"
  end

  resource "nodeenv" do
    url "https://files.pythonhosted.org/packages/f3/9d/a28ecbd1721cd6c0ea65da6bfb2771d31c5d7e32d916a8f643b062530af3/nodeenv-1.7.0.tar.gz"
    sha256 "e0e7f7dfb85fc5394c6fe1e8fa98131a2473e04311a45afb6508f7cf1836fa2b"
  end

  def python3
    "python3.11"
  end

  def install
    # Avoid Cellar path reference, which is only good for one version.
    inreplace "pre_commit/commands/install_uninstall.py",
              "f'INSTALL_PYTHON={shlex.quote(sys.executable)}\\n'",
              "f'INSTALL_PYTHON={shlex.quote(\"#{opt_libexec}/bin/#{python3}\")}\\n'"

    virtualenv_install_with_resources

    # we depend on virtualenv, but that's a separate formula, so install a `.pth` file to link them
    site_packages = Language::Python.site_packages("python3.11")
    virtualenv = Formula["virtualenv"].opt_libexec
    (libexec/site_packages/"homebrew-virtualenv.pth").write virtualenv/site_packages
  end

  # Avoid relative paths
  def post_install
    xy = Language::Python.major_minor_version Formula["python@3.11"].opt_bin/python3
    dirs_to_fix = [libexec/"lib/python#{xy}"]
    dirs_to_fix << (libexec/"bin") if OS.linux?
    dirs_to_fix.each do |folder|
      folder.each_child do |f|
        next unless f.symlink?

        realpath = f.realpath
        rm f
        ln_s realpath, f
      end
    end
  end

  test do
    system "git", "init"
    (testpath/".pre-commit-config.yaml").write <<~EOS
      -   repo: https://github.com/pre-commit/pre-commit-hooks
          sha: v0.9.1
          hooks:
          -   id: trailing-whitespace
    EOS
    system bin/"pre-commit", "install"
    (testpath/"f").write "hi\n"
    system "git", "add", "f"

    ENV["GIT_AUTHOR_NAME"] = "test user"
    ENV["GIT_AUTHOR_EMAIL"] = "test@example.com"
    ENV["GIT_COMMITTER_NAME"] = "test user"
    ENV["GIT_COMMITTER_EMAIL"] = "test@example.com"
    git_exe = which("git")
    ENV["PATH"] = "/usr/bin:/bin"
    system git_exe, "commit", "-m", "test"
  end
end
