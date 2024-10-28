class Libsigrokdecode < Formula
  desc "Drivers for logic analyzers and other supported devices"
  homepage "https://sigrok.org/"
  url "https://sigrok.org/download/source/libsigrokdecode/libsigrokdecode-0.5.3.tar.gz"
  sha256 "c50814aa6743cd8c4e88c84a0cdd8889d883c3be122289be90c63d7d67883fc0"
  license "GPL-3.0-or-later"
  revision 1
  head "git://sigrok.org/libsigrokdecode", branch: "master"

  livecheck do
    url "https://sigrok.org/wiki/Downloads"
    regex(/href=.*?libsigrokdecode[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 3
    sha256 arm64_sequoia: "a1731df4239983986370c4e136346205199c9d1999b4eeb0067c7fc567b02f7f"
    sha256 arm64_sonoma:  "06ea701901cb284067dc6796141c3be85597eb1a6032653b99b9e9c78b9ae1f8"
    sha256 arm64_ventura: "eb410224d2af9d9e6b3a40704afd84cd7a3f6df7598c79b470002a9f6ecdd3d1"
    sha256 sonoma:        "f5e9ec9a38a4e83df28d62965b917dc0809f8c943111920af264847cd2513c28"
    sha256 ventura:       "24e70691499a8ac340debfaead0053f63fd2e708b6e231929ee0644eecd17810"
    sha256 x86_64_linux:  "355ac16e0c4e7e8d896a78e556e079ee9269753e1ecb996dee863593d7f32db1"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => [:build, :test]

  depends_on "glib"
  depends_on "python@3.13"

  on_macos do
    depends_on "gettext"
  end

  def install
    # While this doesn't appear much better than hardcoding `3.10`, this allows
    # `brew audit` to catch mismatches between this line and the dependencies.
    python = "python3.13"
    py_version = Language::Python.major_minor_version(python)

    inreplace "configure.ac" do |s|
      # Force the build system to pick up the right Python 3
      # library. It'll normally scan for a Python library using a list
      # of major.minor versions which means that it might pick up a
      # version that is different from the one specified in the
      # formula.
      s.sub!(/^(SR_PKG_CHECK\(\[python3\], \[SRD_PKGLIBS\],)\n.*$/, "\\1 [python-#{py_version}-embed])")
    end

    if build.head?
      system "./autogen.sh"
    else
      system "autoreconf", "--force", "--install", "--verbose"
    end

    mkdir "build" do
      system "../configure", *std_configure_args, "PYTHON3=#{python}"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libsigrokdecode/libsigrokdecode.h>

      int main() {
        if (srd_init(NULL) != SRD_OK) {
           exit(EXIT_FAILURE);
        }
        if (srd_exit() != SRD_OK) {
           exit(EXIT_FAILURE);
        }
        return 0;
      }
    C
    flags = shell_output("#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs libsigrokdecode").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
