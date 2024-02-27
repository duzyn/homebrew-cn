class Fwupd < Formula
  desc "Firmware update daemon"
  homepage "https://github.com/fwupd/fwupd"
  url "https://mirror.ghproxy.com/https://github.com/fwupd/fwupd/releases/download/1.9.14/fwupd-1.9.14.tar.xz"
  sha256 "b16cbb9480c9a957735d15cfc1e876198b3c607b08e92958f9fc098e31613279"
  license "LGPL-2.1-or-later"
  head "https://github.com/fwupd/fwupd.git", branch: "main"

  bottle do
    sha256 arm64_sonoma:   "e8420a57f1869e440dd78cb9658953443486cea1c7efa0bb6b722d062d4cc82b"
    sha256 arm64_ventura:  "f393c5276ff11532284ee80c92671990817fc7b789d9c6a124bce41076b1de63"
    sha256 arm64_monterey: "8198dba34857a51a9ef4c33b5461d23b9faaf38443002d7e4e312add36778786"
    sha256 sonoma:         "06b59d32eb998c485ac01384836db67bc0890d0421a9696810bdd6b52f2a2cc1"
    sha256 ventura:        "bae1e8380bfae048edf5447727317fda7949aec9353c021b89238b7ba7c4763b"
    sha256 monterey:       "b86c30816926065af71789c4cd0d054762c9c2c99c53607ed77136d6a462387d"
    sha256 x86_64_linux:   "14da0c1cd3fe034fca1a03516ac8d31254b1f2269bc279acf5ad69f6fba31f71"
  end

  depends_on "gi-docgen" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python-jinja" => :build
  depends_on "python-markupsafe" => :build
  depends_on "python@3.12" => :build
  depends_on "vala" => :build
  depends_on "gcab"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "json-glib"
  depends_on "libarchive"
  depends_on "libcbor"
  depends_on "libgusb"
  depends_on "libjcat"
  depends_on "libxmlb"
  depends_on "protobuf-c"

  uses_from_macos "curl"
  uses_from_macos "sqlite"

  def python3
    "python3.12"
  end

  def install
    system "meson", "setup", "build",
                    "-Dbuild=standalone", # this is used as PolicyKit is not available on macOS
                    "-Dlibarchive=enabled", # fail if missing
                    "-Dpython=#{which(python3)}",
                    "-Dsupported_build=enabled",
                    "-Dplugin_flashrom=disabled",
                    "-Dplugin_gpio=disabled",
                    "-Dplugin_modem_manager=disabled",
                    "-Dplugin_msr=disabled",
                    "-Dplugin_tpm=disabled",
                    "-Dplugin_uefi_capsule=disabled",
                    "-Dplugin_uefi_pk=disabled",
                    # these two are needed for https://github.com/fwupd/fwupd/pull/6147
                    "-Dplugin_logitech_scribe=disabled",
                    "-Dplugin_logitech_tap=disabled",
                    *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    # check apps like gnome-firmware can link
    (testpath/"test.c").write <<~EOS
      #include <fwupd.h>
      int main(int argc, char *argv[]) {
        FwupdClient *client = fwupd_client_new();
        g_assert_nonnull(client);
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = %W[
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/fwupd-1
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lfwupd
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"

    # this is a lame test, but fwupdtool requires root access to do anything much interesting
    system "#{bin}/fwupdtool", "-h"
  end
end
