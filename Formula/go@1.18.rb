class GoAT118 < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.18.9.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.18.9.src.tar.gz"
  sha256 "fbe7f09b96aca3db6faeaf180da8bb632868ec049731e355ff61695197c0e3ea"
  license "BSD-3-Clause"

  livecheck do
    url "https://go.dev/dl/"
    regex(/href=.*?go[._-]?v?(1\.18(?:\.\d+)*)[._-]src\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "821f8900a81aa11db09799a33e3da677e56c2f475ab973a616a86bbe5fb6a2cb"
    sha256 arm64_monterey: "139024f08d53dd6dfb5e66a9d53823d9a7b0d5bf01e3c4565aba0f49f1f5dce1"
    sha256 arm64_big_sur:  "50f7f2e773e645eb250c8493a572033573c4fab50e25436a65acebbf17175827"
    sha256 ventura:        "3c97bff80476905423e885fe8988b10cb19f80f85505ff4ea7be3b4c7089f2e4"
    sha256 monterey:       "2678542e4b2d7ecd59f237c33f34c3766ebbde750c5c14953c3ad5064b212c7f"
    sha256 big_sur:        "46cd3dc0e29c5a50ee09a1ff4a9866ed5293030bf23764da891c177a900ddc00"
    sha256 x86_64_linux:   "c5e21dbc2ed057967bfe7323fa12c4990739fd727ee60e329a8f3c5d0d4761d6"
  end

  keg_only :versioned_formula

  # Don't update this unless this version cannot bootstrap the new version.
  resource "gobootstrap" do
    checksums = {
      "darwin-arm64" => "4dac57c00168d30bbd02d95131d5de9ca88e04f2c5a29a404576f30ae9b54810",
      "darwin-amd64" => "6000a9522975d116bf76044967d7e69e04e982e9625330d9a539a8b45395f9a8",
      "linux-arm64"  => "3770f7eb22d05e25fbee8fb53c2a4e897da043eb83c69b9a14f8d98562cd8098",
      "linux-amd64"  => "013a489ebb3e24ef3d915abe5b94c3286c070dfe0818d5bca8108f1d6e8440d2",
    }

    arch = "arm64"
    platform = "darwin"

    on_intel do
      arch = "amd64"
    end

    on_linux do
      platform = "linux"
    end

    boot_version = "1.16"

    url "https://storage.googleapis.com/golang/go#{boot_version}.#{platform}-#{arch}.tar.gz"
    version boot_version
    sha256 checksums["#{platform}-#{arch}"]
  end

  def install
    (buildpath/"gobootstrap").install resource("gobootstrap")
    ENV["GOROOT_BOOTSTRAP"] = buildpath/"gobootstrap"

    cd "src" do
      ENV["GOROOT_FINAL"] = libexec
      system "./make.bash", "--no-clean"
    end

    (buildpath/"pkg/obj").rmtree
    rm_rf "gobootstrap" # Bootstrap not required beyond compile.
    libexec.install Dir["*"]
    bin.install_symlink Dir[libexec/"bin/go*"]

    system bin/"go", "install", "-race", "std"

    # Remove useless files.
    # Breaks patchelf because folder contains weird debug/test files
    (libexec/"src/debug/elf/testdata").rmtree
    # Binaries built for an incompatible architecture
    (libexec/"src/runtime/pprof/testdata").rmtree
  end

  test do
    (testpath/"hello.go").write <<~EOS
      package main

      import "fmt"

      func main() {
          fmt.Println("Hello World")
      }
    EOS
    # Run go fmt check for no errors then run the program.
    # This is a a bare minimum of go working as it uses fmt, build, and run.
    system bin/"go", "fmt", "hello.go"
    assert_equal "Hello World\n", shell_output("#{bin}/go run hello.go")

    ENV["GOOS"] = "freebsd"
    ENV["GOARCH"] = "amd64"
    system bin/"go", "build", "hello.go"
  end
end
