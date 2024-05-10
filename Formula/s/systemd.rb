class Systemd < Formula
  include Language::Python::Virtualenv

  desc "System and service manager"
  homepage "https://wiki.freedesktop.org/www/Software/systemd/"
  url "https://mirror.ghproxy.com/https://github.com/systemd/systemd-stable/archive/refs/tags/v255.6.tar.gz"
  sha256 "7efc8ce8272a64ff32dc4a27cdc7179973d01e7c63d7b2a66df7ed9795574c04"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  head "https://github.com/systemd/systemd.git", branch: "main"

  bottle do
    sha256 x86_64_linux: "54864797f97b0ff5086872c9329de50033808e4eb3b111fda03b31999c4ef2eb"
  end

  depends_on "coreutils" => :build
  depends_on "docbook-xsl" => :build
  depends_on "gettext" => :build
  depends_on "gperf" => :build
  depends_on "intltool" => :build
  depends_on "libgpg-error" => :build
  depends_on "libtool" => :build
  depends_on "libxml2" => :build
  depends_on "libxslt" => :build
  depends_on "m4" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build
  depends_on "rsync" => :build
  depends_on "expat"
  depends_on "glib"
  depends_on "libcap"
  depends_on "libxcrypt"
  depends_on :linux
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "util-linux" # for libmount
  depends_on "xz"
  depends_on "zstd"

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/ed/55/39036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5d/jinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/ea/e2/3834472e7f18801e67a3cd6f3c203a5456d6f7f903cfb9a990e62098a2f3/lxml-5.2.1.tar.gz"
    sha256 "3f7765e69bbce0906a7c74d5fe46d2c7a7596147318dbc08e4a2431f3060e306"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/87/5b/aae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02d/MarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "docbook" do
    url "https://downloads.sourceforge.net/docbook/docbook-xsl/1.79.1/docbook-xsl-1.79.1.tar.bz2?use_mirror=jaist"
    sha256 "725f452e12b296956e8bfb876ccece71eeecdd14b94f667f3ed9091761a4a968"
  end

  resource "oasis-open-4.2" do
    url "https://www.oasis-open.org/docbook/xml/4.2/docbook-xml-4.2.zip"
    sha256 "acc4601e4f97a196076b7e64b368d9248b07c7abf26b34a02cca40eeebe60fa2"
  end

  resource "oasis-open-4.5" do
    url "https://www.oasis-open.org/docbook/xml/4.5/docbook-xml-4.5.zip"
    sha256 "4e4e037a2b83c98c6c94818390d4bdd3f6e10f6ec62dd79188594e26190dc7b4"
  end

  def install
    venv = virtualenv_create(buildpath/"venv", "python3.12")
    venv.pip_install resources.select { |r| r.url.start_with?("https://files.pythonhosted.org/") }
    ENV.prepend_path "PATH", venv.root/"bin"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{lib}/systemd"

    args = %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      -Drootprefix=#{prefix}
      -Dsysvinit-path=#{etc}/init.d
      -Dsysvrcnd-path=#{etc}/rc.d
      -Dpamconfdir=#{etc}/pam.d
      -Dbashcompletiondir=#{bash_completion}
      -Dcreate-log-dirs=false
      -Dhwdb=false
      -Dlz4=true
      -Dgcrypt=false
      -Dp11kit=false
      -Dman=true
    ]

    %w[docbook oasis-open-4.2 oasis-open-4.5].each do |r|
      resource(r).stage "man/#{r}"
    end

    inreplace "man/custom-man.xsl", "http://docbook.sourceforge.net/release/xsl/current/manpages/docbook.xsl",
              "docbook/manpages/docbook.xsl"
    inreplace Dir["man/*.xml"] do |f|
      f.gsub! "http://www.oasis-open.org/docbook/xml/4.2/docbookx.dtd", "oasis-open-4.2/docbookx.dtd", false
      f.gsub! "http://www.oasis-open.org/docbook/xml/4.5/docbookx.dtd", "oasis-open-4.5/docbookx.dtd", false
    end

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_match "temporary: /tmp", shell_output("#{bin}/systemd-path")
  end
end
