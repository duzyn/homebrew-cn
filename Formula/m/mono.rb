class Mono < Formula
  desc "Cross platform, open source .NET development framework"
  homepage "https://www.mono-project.com/"
  url "https://github.com/mono/mono.git",
      tag:      "mono-6.12.0.206",
      revision: "0cbf0e290c31adb476f9de0fa44b1d8829affa40"
  license "MIT"

  livecheck do
    url "https://www.mono-project.com/download/stable/"
    regex(/href=.*?(\d+(?:\.\d+)+)[._-]macos/i)
  end

  bottle do
    sha256 arm64_sonoma:   "d5692da681816af40c7edba43ef788fc8eefc0dfe5633335f988651194648f05"
    sha256 arm64_ventura:  "dc0c5854517667749907915e3fb0bacbc1e01831e772fe22974f95249984c00f"
    sha256 arm64_monterey: "703ae872a253c8aabbbe3df6712e6687d4a03a2d54f240f0e71f2338aef2f74f"
    sha256 sonoma:         "ad71afa361e5dbafaf277e53a39d5408faaec3d43e2d5d2d1efc67dfb6a0167b"
    sha256 ventura:        "048f0e67c2e3136f4577d801704e48456d3afad2a6d53e4853255e7beefbb939"
    sha256 monterey:       "591a82669740d8ac27cbc8167a1bcee320ef12157b4533314b70680a8465bc2a"
    sha256 x86_64_linux:   "303b7ccd6cfd91cecf7d28d8d6c5f95e1751d0c9343eb8ef6bb8642eb3b743ac"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "python@3.12"

  uses_from_macos "unzip" => :build
  uses_from_macos "krb5"
  uses_from_macos "zlib"

  conflicts_with "xsd", because: "both install `xsd` binaries"
  conflicts_with cask: "mono-mdk"
  conflicts_with cask: "homebrew/cask-versions/mono-mdk-for-visual-studio"

  # xbuild requires the .exe files inside the runtime directories to
  # be executable
  skip_clean "lib/mono"

  link_overwrite "lib/mono"
  link_overwrite "lib/cli"

  def install
    # Replace hardcoded /usr/share directory. Paths like /usr/share/.mono,
    # /usr/share/.isolatedstorage, and /usr/share/template are referenced in code.
    inreplace_files = %w[
      external/corefx/src/System.Runtime.Extensions/src/System/Environment.Unix.cs
      mcs/class/corlib/System/Environment.cs
      mcs/class/corlib/System/Environment.iOS.cs
      man/mono-configuration-crypto.1
      man/mono.1
      man/mozroots.1
    ]
    inreplace inreplace_files, %r{/usr/share(?=[/"])}, pkgshare

    # Remove use of -flat_namespace. Upstreamed at
    # https://github.com/mono/mono/pull/21257
    inreplace "mono/profiler/Makefile.am", "-Wl,suppress -Wl,-flat_namespace", "-Wl,dynamic_lookup"

    system "./autogen.sh", *std_configure_args,
                          "--disable-silent-rules",
                          "--disable-nls"
    system "make"
    system "make", "install"
    # mono-gdb.py and mono-sgen-gdb.py are meant to be loaded by gdb, not to be
    # run directly, so we move them out of bin
    libexec.install bin/"mono-gdb.py", bin/"mono-sgen-gdb.py"
  end

  def caveats
    <<~EOS
      To use the assemblies from other formulae you need to set:
        export MONO_GAC_PREFIX="#{HOMEBREW_PREFIX}"
    EOS
  end

  test do
    test_str = "Hello Homebrew"
    test_name = "hello.cs"
    (testpath/test_name).write <<~EOS
      public class Hello1
      {
         public static void Main()
         {
            System.Console.WriteLine("#{test_str}");
         }
      }
    EOS
    shell_output("#{bin}/mcs #{test_name}")
    output = shell_output("#{bin}/mono hello.exe")
    assert_match test_str, output.strip
  end
end
