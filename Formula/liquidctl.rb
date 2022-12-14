class Liquidctl < Formula
  include Language::Python::Virtualenv

  desc "Cross-platform tool and drivers for liquid coolers and other devices"
  homepage "https://github.com/liquidctl/liquidctl"
  url "https://files.pythonhosted.org/packages/b1/25/b7a9f1410baa06f2257296f4229016e4aa2a1fecf318a428cd82437fa7a6/liquidctl-1.12.0.tar.gz"
  sha256 "639e62d8845cd8d3718941e7894865f9c06abfc2826546606335e30f607d6fc3"
  license "GPL-3.0-or-later"
  head "https://github.com/liquidctl/liquidctl.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2adad97b9098cf585537b788dd87153642559de3b2ec5fc858688f4392a53e49"
    sha256 cellar: :any,                 arm64_monterey: "48033c659a3f9768dc797d4d65fdf0500265c0c0b6bd013b2a998ec25568f7ab"
    sha256 cellar: :any,                 arm64_big_sur:  "e46c65919d9d50f93d29cf09e091376b844c3ffa2242ee5ee33c64c2a15c87e4"
    sha256 cellar: :any,                 ventura:        "21dfbac95a50dab244fead84dae4a757a9c6bbf50a9e708c17e7a2b39c7a51a2"
    sha256 cellar: :any,                 monterey:       "a2d51fe7e69d02621540f1d606147f24050c49ded57f3fddd80cfd5ac173ae41"
    sha256 cellar: :any,                 big_sur:        "d1fdbc9932715ebeb050571213b1df5b3fc5578fd528a1a333d024b9c63ecf08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0770fe7ae3123957f054ac117d61e61c66519b830aa477aa0e21498f1588dab"
  end

  depends_on "hidapi"
  depends_on "libusb"
  depends_on "pillow"
  depends_on "python@3.11"

  on_linux do
    depends_on "i2c-tools"
  end

  resource "colorlog" do
    url "https://files.pythonhosted.org/packages/78/6b/4e5481ddcdb9c255b2715f54c863629f1543e97bc8c309d1c5c131ad14f2/colorlog-6.7.0.tar.gz"
    sha256 "bd94bd21c1e13fac7bd3153f4bc3a7dc0eb0974b8bc2fdf1a989e474f6e582e5"
  end

  resource "crcmod" do
    url "https://files.pythonhosted.org/packages/6b/b0/e595ce2a2527e169c3bcd6c33d2473c1918e0b7f6826a043ca1245dd4e5b/crcmod-1.7.tar.gz"
    sha256 "dc7051a0db5f2bd48665a990d3ec1cc305a466a77358ca4492826f41f283601e"
  end

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "hidapi" do
    url "https://files.pythonhosted.org/packages/ef/72/54273f701c737ae5f42d9c0adf641912d20eb955c75433f1093fa509bcc7/hidapi-0.12.0.post2.tar.gz"
    sha256 "8ebb2117be8b27af5c780936030148e1971b6b7fda06e0581ff0bfb15e94ed76"
  end

  resource "pyusb" do
    url "https://files.pythonhosted.org/packages/d9/6e/433a5614132576289b8643fe598dd5d51b16e130fd591564be952e15bb45/pyusb-1.2.1.tar.gz"
    sha256 "a4cc7404a203144754164b8b40994e2849fde1cfff06b08492f12fff9d9de7b9"
  end

  def install
    # customize liquidctl --version
    ENV["DIST_NAME"] = "homebrew"
    ENV["DIST_PACKAGE"] = "liquidctl #{version}"

    python3 = "python3.11"
    venv = virtualenv_create(libexec, python3)

    resource("hidapi").stage do
      inreplace "setup.py" do |s|
        s.gsub! "/usr/include/libusb-1.0", "#{Formula["libusb"].opt_include}/libusb-1.0"
        s.gsub! "/usr/include/hidapi", "#{Formula["hidapi"].opt_include}/hidapi"
      end
      system python3, *Language::Python.setup_install_args(libexec, python3), "--with-system-hidapi"
    end

    venv.pip_install resources.reject { |r| r.name == "hidapi" }
    venv.pip_install_and_link buildpath

    man_page = buildpath/"liquidctl.8"
    # setting the is_macos register to 1 adjusts the man page for macOS
    inreplace man_page, ".nr is_macos 0", ".nr is_macos 1" if OS.mac?
    man.mkpath
    man8.install man_page

    (lib/"udev/rules.d").install Dir["extra/linux/*.rules"] if OS.linux?
  end

  test do
    shell_output "#{bin}/liquidctl list --verbose --debug"
  end
end
