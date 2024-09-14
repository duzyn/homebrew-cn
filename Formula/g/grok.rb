class Grok < Formula
  desc "DRY and RAD for regular expressions and then some"
  homepage "https://github.com/jordansissel/grok"
  license "BSD-2-Clause"
  revision 2
  head "https://github.com/jordansissel/grok.git", branch: "master"

  stable do
    url "https://mirror.ghproxy.com/https://github.com/jordansissel/grok/archive/refs/tags/v0.9.2.tar.gz"
    sha256 "40edbdba488ff9145832c7adb04b27630ca2617384fbef2af014d0e5a76ef636"

    # Backport Makefile fix to support compile on Ubuntu 12.04+
    patch do
      url "https://github.com/jordansissel/grok/commit/f440e9b4ce29a8e803f09d39e37a5725724aba95.patch?full_index=1"
      sha256 "2f92f3b5956224c6d5674940d1d604c1aafa1c3387bda68a266e853c90d0fa86"
    end
  end

  livecheck do
    skip "No longer developed or maintained"
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "b74690719200cd67624f98e63ed4df5bd400ddc82ab728da9ce152b2bb4f0250"
    sha256 cellar: :any,                 arm64_sonoma:   "275855bc35b651480b009f1b186c12a7c031f0aa037d53180266fb319b0b49c5"
    sha256 cellar: :any,                 arm64_ventura:  "37014a946e46e858efa3c43779aeb7f318196ef35cbe453b0d031bfe618f74fc"
    sha256 cellar: :any,                 arm64_monterey: "a30ae8a010c4ac7de6163b2a6b685c9b5ad3149c12d24ab2b765e45d209cadfc"
    sha256 cellar: :any,                 sonoma:         "ecf20a15227d672dbe7cb9756c95e24294715b80361bcda919c47f60edccc524"
    sha256 cellar: :any,                 ventura:        "bc44900cc8642a13759e53187cbdb03495dbb951ece0ab2932127b3f7a08a02d"
    sha256 cellar: :any,                 monterey:       "0e804b8990bd781e846ae402050cbe3119b45f224b43639db710c178eb6d24d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b35c01acc0d3b0640c42c3b003e03bbedccc91bdd0d69294dbbe4ae71e29841"
  end

  depends_on "libevent"
  depends_on "pcre"
  depends_on "tokyo-cabinet"

  uses_from_macos "gperf" => :build

  on_linux do
    depends_on "libtirpc"

    # Fix build with newer gperf.  Upstream issue:
    # https://github.com/jordansissel/grok/issues/29
    # Patch upstreamed here:
    # https://github.com/jordansissel/grok/pull/44
    patch :DATA
  end

  def install
    # Fix compile with newer Clang
    ENV.append "EXTRA_CFLAGS", "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    if OS.linux?
      ENV.append "EXTRA_CFLAGS", "-fcommon"
      ENV.append "EXTRA_CFLAGS", "-I#{Formula["libtirpc"].opt_include}/tirpc"
      ENV.append "EXTRA_LDFLAGS", "-L#{Formula["libtirpc"].opt_lib} -ltirpc"
      ENV["GPERF"] = Formula["gperf"].opt_bin/"gperf"
    end

    # Race condition in generating grok_capture_xdr.h
    ENV.deparallelize
    system "make", "grok"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"grok", "-h"
  end
end

__END__
diff --git a/Makefile b/Makefile
index adfe869..182e015 100644
--- a/Makefile
+++ b/Makefile
@@ -213,8 +213,8 @@ grok_capture_xdr.h: grok_capture.x
 	rpcgen -h $< -o $@
 
 %.c: %.gperf
-	@if $(GPERF) --version | head -1 | egrep -v '3\.[0-9]+\.[0-9]+' ; then \
-		echo "We require gperf version >= 3.0.3" ; \
+	@if $(GPERF) --version | head -1 | egrep -v '3\.[1-9]+' ; then \
+		echo "We require gperf version >= 3.1" ; \
 		exit 1; \
 	fi
 	$(GPERF) $< > $@
diff --git a/grok_matchconf_macro.h b/grok_matchconf_macro.h
index 85876f6..f1fe1f3 100644
--- a/grok_matchconf_macro.h
+++ b/grok_matchconf_macro.h
@@ -19,6 +19,6 @@ struct strmacro {
 #endif
 
 /* this function is generated by gperf */
-const struct strmacro *patname2macro(const char *str, unsigned int len);
+const struct strmacro *patname2macro(const char *str, size_t len);
 
 #endif /* _GROK_MATCHCONF_MACRO_ */
