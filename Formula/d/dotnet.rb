class Dotnet < Formula
  desc ".NET Core"
  homepage "https://dotnet.microsoft.com/"
  license "MIT"
  version_scheme 1
  head "https://github.com/dotnet/dotnet.git", branch: "main"

  stable do
    # Source-build tag announced at https://github.com/dotnet/source-build/discussions
    url "https://mirror.ghproxy.com/https://github.com/dotnet/dotnet/archive/refs/tags/v10.0.101.tar.gz"
    sha256 "cac1181919374d061ff73e7e58cc9f7a5480acb0c8dc2e309c5bd844217f7962"

    resource "release.json" do
      url "https://mirror.ghproxy.com/https://github.com/dotnet/dotnet/releases/download/v10.0.101/release.json"
      sha256 "9c27aa3643fa1562356bb8c4ab0a94fa22f7d2d23bdc546ecf61ed089cb4ffa1"

      livecheck do
        formula :parent
      end
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2d5fbb0e7b7c483898afb76d882e0bac871f7dfbdacde9f43c2b4669cbeb1e32"
    sha256 cellar: :any,                 arm64_sequoia: "99efb1b371be439b59f16e6bfe918bbe923f283f49ac472c627349960e8bfbe6"
    sha256 cellar: :any,                 arm64_sonoma:  "6135d2357bbebf28d1fa35d68e65acb5d4bf53ca921c761630fd1bb53a5a8faf"
    sha256 cellar: :any,                 sonoma:        "88043ff87736c9dce2f25c7cc21e9bc4a5ec01ab1728c16e9e93c136feec9dbe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01cc5e37350b0d4de0de52f8a094863a21cdda2c1d0a01a344dd565312530d48"
    sha256                               x86_64_linux:  "93d7fdd268437cc2e54a3378b08a5961f5f7208b1a6afad097837e36290c95cd"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rapidjson" => :build
  depends_on "brotli"
  depends_on "icu4c@78"
  depends_on "openssl@3"

  uses_from_macos "python" => :build
  uses_from_macos "krb5"
  uses_from_macos "zlib"

  on_macos do
    depends_on "bash" => :build
    depends_on "grep" => :build # grep: invalid option -- P
  end

  on_linux do
    depends_on "libunwind"
    depends_on "lttng-ust"

    on_intel do
      depends_on "llvm" => :build

      fails_with :gcc do
        cause "Illegal instruction when running crossgen2"
      end
    end
  end

  conflicts_with cask: "dotnet-runtime"
  conflicts_with cask: "dotnet-runtime@preview"
  conflicts_with cask: "dotnet-sdk"
  conflicts_with cask: "dotnet-sdk@preview"

  def install
    # Make sure CoreCLR builds with our compiler shims
    ENV["CLR_CC"] = which(ENV.cc)
    ENV["CLR_CXX"] = which(ENV.cxx)

    # Fixes build error where member names shadow type names
    # Error: declaration of '...' changes meaning of '...'
    inreplace "src/runtime/src/coreclr/jit/gentree.h" do |s|
      s.gsub! "    ExecutionContextHandling    ExecutionContextHandling",
              "    ::ExecutionContextHandling    ExecutionContextHandling"
      s.gsub! "= ExecutionContextHandling::None;",
              "= ::ExecutionContextHandling::None;"

      s.gsub! "    ContinuationContextHandling ContinuationContextHandling",
              "    ::ContinuationContextHandling ContinuationContextHandling"
      s.gsub! "= ContinuationContextHandling::None;",
              "= ::ContinuationContextHandling::None;"
    end

    # Work around https://github.com/dotnet/dotnet/issues/4037 using the last
    # valid version (2025-12-31 => 61231). Remove when upstream issue is fixed.
    f = "src/source-build-reference-packages/src/externalPackages/src" \
        "/azure-activedirectory-identitymodel-extensions-for-dotnet/build/common.props"
    inreplace f, '.$([System.DateTime]::Now.AddYears(-2019).Year)$([System.DateTime]::Now.ToString("MMdd"))', ".61231"

    if OS.mac?
      # Need GNU grep (Perl regexp support) to use release manifest rather than git repo
      ENV.prepend_path "PATH", Formula["grep"].libexec/"gnubin"

      # Avoid mixing CLT and Xcode.app when building CoreCLR component which can
      # cause undefined symbols, e.g. __swift_FORCE_LOAD_$_swift_Builtin_float
      ENV["SDKROOT"] = MacOS.sdk_for_formula(self).path

      # Skip installer build on macOS - prevents CreatePkg target errors
      # See: https://github.com/dotnet/runtime/issues/122832
      inreplace "src/runtime/Directory.Build.props" do |s|
        s.gsub! "</Project>",
                "<PropertyGroup>\n    <SkipInstallerBuild>true</SkipInstallerBuild>\n  </PropertyGroup>\n</Project>"
      end
      inreplace "src/aspnetcore/Directory.Build.props" do |s|
        s.gsub! "</Project>",
                "<PropertyGroup>\n    <SkipInstallerBuild>true</SkipInstallerBuild>\n  </PropertyGroup>\n</Project>"
      end
    else
      icu4c_dep = deps.find { |dep| dep.name.match?(/^icu4c(@\d+)?$/) }
      ENV.append_path "LD_LIBRARY_PATH", icu4c_dep.to_formula.opt_lib
    end
    args = ["--clean-while-building", "--source-build", "--branding", "rtm",
            "--with-system-libs", "brotli+libunwind+rapidjson+zlib"]
    if build.stable?
      args += ["--release-manifest", "release.json"]
      odie "Update release.json resource!" if resource("release.json").version != version
      buildpath.install resource("release.json")
    end

    system "./prep-source-build.sh"
    system "./build.sh", *args

    libexec.mkpath
    tarball = buildpath.glob("artifacts/*/Release/dotnet-sdk-*.tar.gz").first
    system "tar", "--extract", "--file", tarball, "--directory", libexec
    doc.install libexec.glob("*.txt")
    (bin/"dotnet").write_env_script libexec/"dotnet", DOTNET_ROOT: libexec

    bash_completion.install "src/sdk/scripts/register-completions.bash" => "dotnet"
    zsh_completion.install "src/sdk/scripts/register-completions.zsh" => "_dotnet"
    man1.install Utils::Gzip.compress(*buildpath.glob("src/sdk/documentation/manpages/sdk/*.1"))
    man7.install Utils::Gzip.compress(*buildpath.glob("src/sdk/documentation/manpages/sdk/*.7"))
  end

  def caveats
    <<~CAVEATS
      For other software to find dotnet you may need to set:
        export DOTNET_ROOT="#{opt_libexec}"
    CAVEATS
  end

  test do
    target_framework = "net#{version.major_minor}"

    (testpath/"test.cs").write <<~CS
      using System;

      namespace Homebrew
      {
        public class Dotnet
        {
          public static void Main(string[] args)
          {
            var joined = String.Join(",", args);
            Console.WriteLine(joined);
          }
        }
      }
    CS

    (testpath/"test.csproj").write <<~XML
      <Project Sdk="Microsoft.NET.Sdk">
        <PropertyGroup>
          <OutputType>Exe</OutputType>
          <TargetFrameworks>#{target_framework}</TargetFrameworks>
          <PlatformTarget>AnyCPU</PlatformTarget>
          <RootNamespace>Homebrew</RootNamespace>
          <PackageId>Homebrew.Dotnet</PackageId>
          <Title>Homebrew.Dotnet</Title>
          <Product>$(AssemblyName)</Product>
          <EnableDefaultCompileItems>false</EnableDefaultCompileItems>
        </PropertyGroup>
        <ItemGroup>
          <Compile Include="test.cs" />
        </ItemGroup>
      </Project>
    XML

    system bin/"dotnet", "build", "--framework", target_framework, "--output", testpath, testpath/"test.csproj"
    output = shell_output("#{bin}/dotnet run --framework #{target_framework} #{testpath}/test.dll a b c")
    # We switched to `assert_match` due to progress status ANSI codes in output.
    # TODO: Switch back to `assert_equal` once fixed in release.
    # Issue ref: https://github.com/dotnet/sdk/issues/44610
    assert_match "#{testpath}/test.dll,a,b,c\n", output

    # Test to avoid uploading broken Intel Sonoma bottle which has stack overflow on restore.
    # See https://github.com/Homebrew/homebrew-core/issues/197546
    resource "docfx" do
      url "https://mirror.ghproxy.com/https://github.com/dotnet/docfx/archive/refs/tags/v2.78.3.tar.gz"
      sha256 "d97142ff71bd84e200e6d121f09f57d28379a0c9d12cb58f23badad22cc5c1b7"
    end
    resource("docfx").stage do
      system bin/"dotnet", "restore", "src/docfx", "--disable-build-servers", "--no-cache"
    end
  end
end
