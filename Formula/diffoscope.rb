class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/ff/b1/ec60a3cf538c88eeaaa852a0df3964522a7c805ba4757c3c2b9881726e6c/diffoscope-228.tar.gz"
  sha256 "ff5d656eb6699f0fcd077146d2af44307c34ba9190c7b531d0e5accc8aeef869"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6107cad3e0265e67dc26d5a1eaccbd692d79d60e640e9a6b88d30f0bfe171bff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8394bd6d54ea2f52590d092e931626f86fe8fd89450a401986b9ba191894d9d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e1b87c4da01936b175340f6e1ac8045d0495b0746e6dfbfbb4a6e84187d76a66"
    sha256 cellar: :any_skip_relocation, ventura:        "de2fbb39cf31a50bb4cae705d6d4b5f180f1466c86778ac4958e1febef27291c"
    sha256 cellar: :any_skip_relocation, monterey:       "2036f94fd0e965fd6d2912bc7561edaa91347359f8d5efc35c7e6dded45da568"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a0bca62078b0e7b533838551e1457989031a4e266443a06563e22312fcd9ea0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "252c04fb70c352f27ec8e4fccb33179d1debd20c031ec8a5d04e3e0d23c376df"
  end

  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "python@3.11"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/05/f8/67851ae4fe5396ba6868c5d84219b81ea6a5d53991a6853616095c30adc0/argcomplete-2.0.0.tar.gz"
    sha256 "6372ad78c89d662035101418ae253668445b391755cfe94ea52f1b9d22425b20"
  end

  resource "libarchive-c" do
    url "https://files.pythonhosted.org/packages/93/c4/d8fa5dfcfef8aa3144ce4cfe4a87a7428b9f78989d65e9b4aa0f0beda5a8/libarchive-c-4.0.tar.gz"
    sha256 "a5b41ade94ba58b198d778e68000f6b7de41da768de7140c984f71d7fa8416e5"
  end

  resource "progressbar" do
    url "https://files.pythonhosted.org/packages/a3/a6/b8e451f6cff1c99b4747a2f7235aa904d2d49e8e1464e0b798272aa84358/progressbar-2.5.tar.gz"
    sha256 "5d81cb529da2e223b53962afd6c8ca0f05c6670e40309a7219eacc36af9b6c63"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/da/db/0b3e28ac047452d079d375ec6798bf76a036a08182dbb39ed38116a49130/python-magic-0.4.27.tar.gz"
    sha256 "c1ba14b08e4a5f5c31a302b7721239695b2f0f058d125bd5ce1ee36b9d9d3c3b"
  end

  def install
    venv = virtualenv_create(libexec, "python3.11")
    venv.pip_install resources
    venv.pip_install buildpath

    bin.install libexec/"bin/diffoscope"
    libarchive = Formula["libarchive"].opt_lib/shared_library("libarchive")
    bin.env_script_all_files(libexec/"bin", LIBARCHIVE: libarchive)
  end

  test do
    (testpath/"test1").write "test"
    cp testpath/"test1", testpath/"test2"
    system bin/"diffoscope", "--progress", "test1", "test2"
  end
end
