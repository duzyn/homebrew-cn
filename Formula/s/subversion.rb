class Subversion < Formula
  desc "Version control system designed to be a better CVS"
  homepage "https://subversion.apache.org/"
  license "Apache-2.0"

  stable do
    url "https://www.apache.org/dyn/closer.lua?path=subversion/subversion-1.14.4.tar.bz2"
    mirror "https://archive.apache.org/dist/subversion/subversion-1.14.4.tar.bz2"
    sha256 "44ead116e72e480f10f123c914bb6f9f8c041711c041ed7abff1b8634a199e3c"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://mirror.ghproxy.com/https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  bottle do
    sha256 arm64_sequoia: "b5ee51fc359b00683fdc3ab0832a54162591974f39d57bff2d2126ce18799e83"
    sha256 arm64_sonoma:  "c632a21696b5c276101d816521079f369ef509edb9ef8fc61ac50e8114d602af"
    sha256 arm64_ventura: "d001086b2e739b5297d6f60c5110432a543b3afffa989a055d1ff45f6c0921bd"
    sha256 sonoma:        "36212320f74a821399a0341fe5a0807b5af4722845b29a7ee3963713d77fa84a"
    sha256 ventura:       "8a8874c52aeafc429d7b1f0afe6c27285e23e7290bab6c63ba9209e895c81a1c"
    sha256 x86_64_linux:  "be92c9fe84bb90f6f6c3ed859dd9050b9e17ea8e1beb572107a9903f2a982994"
  end

  head do
    url "https://github.com/apache/subversion.git", branch: "trunk"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.12" => [:build, :test]
  depends_on "scons" => :build # For Serf
  depends_on "swig" => :build
  depends_on "apr"
  depends_on "apr-util"

  # build against Homebrew versions of
  # gettext, lz4 and utf8proc for consistency
  depends_on "gettext"
  depends_on "lz4"
  depends_on "openssl@3" # For Serf
  depends_on "utf8proc"

  uses_from_macos "expat"
  uses_from_macos "krb5"
  uses_from_macos "perl"
  uses_from_macos "ruby"
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  on_macos do
    # Prevent "-arch ppc" from being pulled in from Perl's $Config{ccflags}
    patch :DATA
  end

  on_linux do
    depends_on "libtool" => :build
  end

  resource "py3c" do
    url "https://mirror.ghproxy.com/https://github.com/encukou/py3c/archive/refs/tags/v1.4.tar.gz"
    sha256 "abc745079ef906148817f4472c3fb4bc41d62a9ea51a746b53e09819494ac006"
  end

  resource "serf" do
    url "https://www.apache.org/dyn/closer.lua?path=serf/serf-1.3.10.tar.bz2"
    mirror "https://archive.apache.org/dist/serf/serf-1.3.10.tar.bz2"
    sha256 "be81ef08baa2516ecda76a77adf7def7bc3227eeb578b9a33b45f7b41dc064e6"
  end

  def python3
    "python3.12"
  end

  def install
    py3c_prefix = buildpath/"py3c"
    serf_prefix = libexec/"serf"

    resource("py3c").unpack py3c_prefix
    resource("serf").stage do
      if OS.linux?
        inreplace "SConstruct" do |s|
          s.gsub! "env.Append(LIBPATH=['$OPENSSL/lib'])",
          "\\1\nenv.Append(CPPPATH=['$ZLIB/include'])\nenv.Append(LIBPATH=['$ZLIB/lib'])"
        end
      end

      inreplace "SConstruct" do |s|
        s.gsub! "variables=opts,",
        "variables=opts, RPATHPREFIX = '-Wl,-rpath,',"
      end

      # scons ignores our compiler and flags unless explicitly passed
      krb5 = if OS.mac?
        "/usr"
      else
        Formula["krb5"].opt_prefix
      end

      args = %W[
        PREFIX=#{serf_prefix} GSSAPI=#{krb5} CC=#{ENV.cc}
        CFLAGS=#{ENV.cflags} LINKFLAGS=#{ENV.ldflags}
        OPENSSL=#{Formula["openssl@3"].opt_prefix}
        APR=#{Formula["apr"].opt_prefix}
        APU=#{Formula["apr-util"].opt_prefix}
      ]

      args << "ZLIB=#{Formula["zlib"].opt_prefix}" if OS.linux?

      scons = Formula["scons"].opt_bin/"scons"
      system scons, *args
      system scons, "install"
    end

    # Use existing system zlib and sqlite
    zlib = if OS.mac?
      "#{MacOS.sdk_path_if_needed}/usr"
    else
      Formula["zlib"].opt_prefix
    end

    sqlite = if OS.mac?
      "#{MacOS.sdk_path_if_needed}/usr"
    else
      Formula["sqlite"].opt_prefix
    end

    # Use dep-provided other libraries
    # Don't mess with Apache modules (since we're not sudo)
    if OS.linux?
      # svn can't find libserf-1.so.1 at runtime without this
      ENV.append "LDFLAGS", "-Wl,-rpath=#{serf_prefix}/lib"
      # Fix linkage when build-from-source as brew disables superenv when
      # `scons` is a dependency. Can remove if serf is moved to a separate
      # formula or when serf's cmake support is stable.
      ENV.append "LDFLAGS", "-Wl,-rpath=#{HOMEBREW_PREFIX}/lib" unless build.bottle?
    end

    perl = DevelopmentTools.locate("perl")
    ruby = DevelopmentTools.locate("ruby")

    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --enable-optimize
      --disable-mod-activation
      --disable-plaintext-password-storage
      --with-apr-util=#{Formula["apr-util"].opt_prefix}
      --with-apr=#{Formula["apr"].opt_prefix}
      --with-apxs=no
      --with-ruby-sitedir=#{lib}/ruby
      --with-py3c=#{py3c_prefix}
      --with-serf=#{serf_prefix}
      --with-sqlite=#{sqlite}
      --with-swig=#{Formula["swig"].opt_prefix}
      --with-zlib=#{zlib}
      --without-apache-libexecdir
      --without-berkeley-db
      --without-gpg-agent
      --without-jikes
      PERL=#{perl}
      PYTHON=#{which(python3)}
      RUBY=#{ruby}
    ]

    # preserve compatibility with macOS 12.0–12.2
    args.unshift "--enable-sqlite-compatibility-version=3.36.0" if OS.mac? && MacOS.version == :monterey

    inreplace "Makefile.in",
              "toolsdir = @bindir@/svn-tools",
              "toolsdir = @libexecdir@/svn-tools"

    # regenerate configure file as we patched `build/ac-macros/swig.m4`
    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make"
    ENV.deparallelize { system "make", "install" }
    bash_completion.install "tools/client-side/bash_completion" => "subversion"

    system "make", "tools"
    system "make", "install-tools"

    system "make", "swig-py"
    system "make", "install-swig-py"
    (prefix/Language::Python.site_packages(python3)).install_symlink Dir["#{lib}/svn-python/*"]

    perl_archlib = Utils.safe_popen_read(perl.to_s, "-MConfig", "-e", "print $Config{archlib}")
    perl_core = Pathname.new(perl_archlib)/"CORE"
    perl_extern_h = perl_core/"EXTERN.h"

    if OS.mac? && !perl_extern_h.exist?
      # No EXTERN.h, maybe it's system perl
      perl_version = Utils.safe_popen_read(perl.to_s, "--version")[/v(\d+\.\d+)(?:\.\d+)?/, 1]
      perl_core = MacOS.sdk_path/"System/Library/Perl"/perl_version/"darwin-thread-multi-2level/CORE"
      perl_extern_h = perl_core/"EXTERN.h"
    end

    onoe "'#{perl_extern_h}' does not exist" unless perl_extern_h.exist?

    if OS.mac?
      inreplace "Makefile" do |s|
        s.change_make_var! "SWIG_PL_INCLUDES",
          "$(SWIG_INCLUDES) -arch #{Hardware::CPU.arch} -g -pipe -fno-common " \
          "-DPERL_DARWIN -fno-strict-aliasing -I#{HOMEBREW_PREFIX}/include -I#{perl_core}"
      end
    end
    system "make", "swig-pl-lib"
    system "make", "install-swig-pl-lib"
    cd "subversion/bindings/swig/perl/native" do
      system perl, "Makefile.PL", "PREFIX=#{prefix}", "INSTALLSITEMAN3DIR=#{man3}"
      ENV.deparallelize { system "make", "install" }
    end

    # This is only created when building against system Perl, but it isn't
    # purged by Homebrew's post-install cleaner because that doesn't check
    # "Library" directories. It is however pointless to keep around as it
    # only contains the perllocal.pod installation file.
    rm_r(prefix/"Library/Perl") if (prefix/"Library/Perl").exist?
  end

  def caveats
    <<~EOS
      svntools have been installed to:
        #{opt_libexec}

      The perl bindings are located in various subdirectories of:
        #{opt_lib}/perl5
    EOS
  end

  test do
    system bin/"svnadmin", "create", "test"
    system bin/"svnadmin", "verify", "test"
    system bin/"svn", "checkout", "file://#{testpath}/test", "svn-test"

    platform = if OS.mac?
      "darwin-thread-multi-2level"
    else
      "#{Hardware::CPU.arch}-#{OS.kernel_name.downcase}-thread-multi"
    end

    perl = DevelopmentTools.locate("perl")

    perl_version = Utils.safe_popen_read(perl.to_s, "--version")[/v(\d+\.\d+(?:\.\d+)?)/, 1]
    ENV["PERL5LIB"] = "#{lib}/perl5/site_perl/#{perl_version}/#{platform}"
    system perl, "-e", "use SVN::Client; new SVN::Client()"

    system python3, "-c", "import svn.client, svn.repos"
  end
end

__END__
diff --git a/subversion/bindings/swig/perl/native/Makefile.PL.in b/subversion/bindings/swig/perl/native/Makefile.PL.in
index a60430b..bd9b017 100644
--- a/subversion/bindings/swig/perl/native/Makefile.PL.in
+++ b/subversion/bindings/swig/perl/native/Makefile.PL.in
@@ -76,10 +76,13 @@ my $apr_ldflags = '@SVN_APR_LIBS@'

 chomp $apr_shlib_path_var;

+my $config_ccflags = $Config{ccflags};
+$config_ccflags =~ s/-arch\s+\S+//g;
+
 my %config = (
     ABSTRACT => 'Perl bindings for Subversion',
     DEFINE => $cppflags,
-    CCFLAGS => join(' ', $cflags, $Config{ccflags}),
+    CCFLAGS => join(' ', $cflags, $config_ccflags),
     INC  => join(' ', $includes, $cppflags,
                  " -I$swig_srcdir/perl/libsvn_swig_perl",
                  " -I$svnlib_srcdir/include",
