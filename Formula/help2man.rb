class Help2man < Formula
  desc "Automatically generate simple man pages"
  homepage "https://www.gnu.org/software/help2man/"
  url "https://ftp.gnu.org/gnu/help2man/help2man-1.49.3.tar.xz"
  mirror "https://ftpmirror.gnu.org/help2man/help2man-1.49.3.tar.xz"
  sha256 "4d7e4fdef2eca6afe07a2682151cea78781e0a4e8f9622142d9f70c083a2fd4f"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fba233e327acdda68edc9c3af88122aeee734e6636e3da2f9af15e9730f13b0e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fba233e327acdda68edc9c3af88122aeee734e6636e3da2f9af15e9730f13b0e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fba233e327acdda68edc9c3af88122aeee734e6636e3da2f9af15e9730f13b0e"
    sha256 cellar: :any,                 ventura:        "63016e1dab1db06d4bfb4a8bd6b28ec76973c3e6ae61ae2cdc98fb413b4c8bb1"
    sha256 cellar: :any,                 monterey:       "8219610cec9b20f4c4a6f50a836d2cc545045a1a2f285d4be5b03300b96ba760"
    sha256 cellar: :any,                 big_sur:        "e84b7251622aaaa026961c936de0802bb8aa02bbace010765b9c75d941b819e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3180d4a66aea5c6fc513255d36cbc34bc97d155361965cb93de87e206a1d2ea"
  end

  uses_from_macos "perl", since: :mojave

  on_intel do
    depends_on "gettext"
  end

  resource "Locale::gettext" do
    url "https://cpan.metacpan.org/authors/id/P/PV/PVANDRY/gettext-1.07.tar.gz"
    sha256 "909d47954697e7c04218f972915b787bd1244d75e3bd01620bc167d5bbc49c15"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    if Hardware::CPU.intel?
      resource("Locale::gettext").stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "install"
      end
    end

    # install is not parallel safe
    # see https://github.com/Homebrew/homebrew/issues/12609
    ENV.deparallelize

    args = []
    args << "--enable-nls" if Hardware::CPU.intel?

    system "./configure", "--prefix=#{prefix}", *args
    system "make", "install"
    (libexec/"bin").install "#{bin}/help2man"
    (bin/"help2man").write_env_script("#{libexec}/bin/help2man", PERL5LIB: ENV["PERL5LIB"])
  end

  test do
    out = if Hardware::CPU.intel?
      shell_output("#{bin}/help2man --locale=en_US.UTF-8 #{bin}/help2man")
    else
      shell_output("#{bin}/help2man #{bin}/help2man")
    end

    assert_match "help2man #{version}", out
  end
end
