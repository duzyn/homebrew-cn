class Deno < Formula
  desc "Secure runtime for JavaScript and TypeScript"
  homepage "https://deno.com/"
  url "https://mirror.ghproxy.com/https://github.com/denoland/deno/releases/download/v2.2.2/deno_src.tar.gz"
  sha256 "0c802c7ed0035739d2c0b836de24a0f4215a1a864226573b12412e6516f5d198"
  license "MIT"
  head "https://github.com/denoland/deno.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7bbbbabfd174c97a6fd42703b62cd7b490817a04ed42fe4bcc552590924a8673"
    sha256 cellar: :any,                 arm64_sonoma:  "adc73ba0dbf31dac04b96c3929c5f86ed2a3c2f170287f4e82e9558ea0170874"
    sha256 cellar: :any,                 arm64_ventura: "5640afbab0f9713ffb05540e9dddb8294c5f0e5cb95115c2b58702c6a5f7dfaf"
    sha256 cellar: :any,                 sonoma:        "8ec7b9891b982334dfadf71a5c16a91396418ce5a06e905adb67588e0758a905"
    sha256 cellar: :any,                 ventura:       "54d32cfdf2287a98449f335887c1fb625af307a33c2839d3a703bd5be5f97296"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "215bd0b5e3d2d5114cbb99cb61ec12da84c06f65bcc728cc76eb9676a4ec67ec"
  end

  depends_on "cmake" => :build
  depends_on "lld" => :build
  depends_on "llvm" => :build
  depends_on "ninja" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build
  depends_on xcode: ["15.0", :build] # v8 12.9+ uses linker flags introduced in xcode 15
  depends_on "sqlite" # needs `sqlite3_unlock_notify`

  uses_from_macos "python" => :build, since: :catalina
  uses_from_macos "libffi"
  uses_from_macos "xz"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "glib"
  end

  # Temporary resources to work around build failure due to files missing from crate
  # We use the crate as GitHub tarball lacks submodules and this allows us to avoid git overhead.
  # TODO: Remove this and `v8` resource when https://github.com/denoland/rusty_v8/issues/1065 is resolved
  # VERSION=#{version} && curl -s https://mirror.ghproxy.com/https://raw.githubusercontent.com/denoland/deno/v$VERSION/Cargo.lock | grep -C 1 'name = "v8"'
  resource "rusty_v8" do
    url "https://static.crates.io/crates/v8/v8-134.4.0.crate"
    sha256 "224c6c3d1fd3c0356224b2ad355b61c242cdafa9d14cc31b7f161ea177b3b4e9"
  end

  # Find the v8 version from the last commit message at:
  # https://github.com/denoland/rusty_v8/commits/v#{rusty_v8_version}/v8
  # Then, use the corresponding tag found in https://github.com/denoland/v8/tags
  resource "v8" do
    url "https://mirror.ghproxy.com/https://github.com/denoland/v8/archive/refs/tags/13.4.114.9-denoland-ed8e5975a290a84ae9aa.tar.gz"
    sha256 "cb747dd9531fb16905095ac00664c8925aadd0bc2b04f3a71074f658c8e8e609"
  end

  # VERSION=#{version} && curl -s https://mirror.ghproxy.com/https://raw.githubusercontent.com/denoland/deno/v$VERSION/Cargo.lock | grep -C 1 'name = "deno_core"'
  resource "deno_core" do
    url "https://mirror.ghproxy.com/https://github.com/denoland/deno_core/archive/refs/tags/0.338.0.tar.gz"
    sha256 "de43ab683064b7061c5e8757c311ac4043cdabf2a025c51a2f113e61a635ac51"
  end

  # The latest commit from `denoland/icu`, go to https://github.com/denoland/rusty_v8/tree/v#{rusty_v8_version}/third_party
  # and check the commit of the `icu` directory
  resource "icu" do
    url "https://mirror.ghproxy.com/https://github.com/denoland/icu/archive/a22a8f24224ddda8b856437d7e8560de1da3f8e1.tar.gz"
    sha256 "649c1d76e08e3bfb87ebc478bed2a1909e5505aadc98ebe71406c550626b4225"
  end

  # V8_TAG=#{v8_resource_tag} && curl -s https://mirror.ghproxy.com/https://raw.githubusercontent.com/denoland/v8/$V8_TAG/DEPS | grep gn_version
  resource "gn" do
    url "https://gn.googlesource.com/gn.git",
        revision: "ed1abc107815210dc66ec439542bee2f6cbabc00"
  end

  def llvm
    Formula["llvm"]
  end

  def install
    # Work around files missing from crate
    # TODO: Remove this at the same time as `rusty_v8` + `v8` resources
    resource("rusty_v8").stage buildpath/"../rusty_v8"
    resource("v8").stage do
      cp_r "tools/builtins-pgo", buildpath/"../rusty_v8/v8/tools/builtins-pgo"
    end
    resource("icu").stage do
      cp_r "common", buildpath/"../rusty_v8/third_party/icu/common"
    end

    resource("deno_core").stage buildpath/"../deno_core"

    # Avoid vendored dependencies.
    inreplace "ext/ffi/Cargo.toml",
              /^libffi-sys = "(.+)"$/,
              'libffi-sys = { version = "\\1", features = ["system"] }'
    inreplace "Cargo.toml",
              /^rusqlite = { version = "(.+)", features = \["unlock_notify", "bundled", "session"\] }$/,
              'rusqlite = { version = "\\1", features = ["unlock_notify", "session"] }'

    if OS.mac? && (MacOS.version < :mojave)
      # Overwrite Chromium minimum SDK version of 10.15
      ENV["FORCE_MAC_SDK_MIN"] = MacOS.version
    end

    python3 = which("python3")
    # env args for building a release build with our python3, ninja and gn
    ENV["PYTHON"] = python3
    ENV["GN"] = buildpath/"gn/out/gn"
    ENV["NINJA"] = which("ninja")
    # build rusty_v8 from source
    ENV["V8_FROM_SOURCE"] = "1"
    # Build with llvm and link against system libc++ (no runtime dep)
    ENV["CLANG_BASE_PATH"] = llvm.prefix

    # use our clang version, and disable lld because the build assumes the lld
    # supports features from newer clang versions (>=20)
    clang_version = llvm.version.major
    ENV["GN_ARGS"] = "clang_version=#{clang_version} use_lld=false"

    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    ENV.remove "HOMEBREW_LIBRARY_PATHS", llvm.opt_lib

    resource("gn").stage buildpath/"gn"
    cd "gn" do
      system python3, "build/gen.py"
      system "ninja", "-C", "out"
    end

    # cargo seems to build rusty_v8 twice in parallel, which causes problems,
    # hence the need for ENV.deparallelize
    # Issue ref: https://github.com/denoland/deno/issues/9244
    ENV.deparallelize do
      system "cargo", "--config", ".cargo/local-build.toml",
                      "install", "--no-default-features", "-vv",
                      *std_cargo_args(path: "cli")
    end

    generate_completions_from_executable(bin/"deno", "completions")
  end

  test do
    require "utils/linkage"

    IO.popen("deno run -A -r https://fresh.deno.dev fresh-project", "r+") do |pipe|
      pipe.puts "n"
      pipe.puts "n"
      pipe.close_write
      pipe.read
    end

    assert_match "# Fresh project", (testpath/"fresh-project/README.md").read

    (testpath/"hello.ts").write <<~TYPESCRIPT
      console.log("hello", "deno");
    TYPESCRIPT
    assert_match "hello deno", shell_output("#{bin}/deno run hello.ts")
    assert_match "Welcome to Deno!",
      shell_output("#{bin}/deno run https://deno.land/std@0.100.0/examples/welcome.ts")

    linked_libraries = [
      Formula["sqlite"].opt_lib/shared_library("libsqlite3"),
    ]
    unless OS.mac?
      linked_libraries += [
        Formula["libffi"].opt_lib/shared_library("libffi"),
      ]
    end
    linked_libraries.each do |library|
      assert Utils.binary_linked_to_library?(bin/"deno", library),
              "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
