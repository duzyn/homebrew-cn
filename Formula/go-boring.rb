class GoBoring < Formula
  desc "Go programming language with BoringCrypto"
  homepage "https://go.googlesource.com/go/+/dev.boringcrypto/README.boringcrypto.md"
  url "https://go-boringcrypto.storage.googleapis.com/go1.18.9b7.src.tar.gz"
  version "1.18.9b7"
  sha256 "45b1ed1d3f63d1fa86c6f26329f11912c1dbfb1fa4fd39cf0eabc84e29f86cd7"
  license "BSD-3-Clause"

  livecheck do
    url "https://go-boringcrypto.storage.googleapis.com/"
    regex(/>go[._-]?(\d+(?:\.\d+)+b\d+)[._-]src\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "9dd33cf77ccfb193d8374bde4b515955fa6caca1dcd05e3a921e7f7461b3f6c1"
    sha256 arm64_monterey: "02f4fadc9a0fd8db1d744a6c8316c9acbbdc44cbc88a735854029725f629ecef"
    sha256 arm64_big_sur:  "f930766afc5208c1001480a04fbc35deadb4a7f1317fc602ea6f4569d4771b18"
    sha256 ventura:        "fa33c636178c0f1c886b22d851d693df3dae575afb4a0df98492186c15105753"
    sha256 monterey:       "3e5ee20e100ce5c293bb7356fec1fe6e813f43e83d0b5c707099834c82531c2c"
    sha256 big_sur:        "e3c2950e016640191265a09ff69aaf800a10711022b8358a287fca1dd9bc1325"
    sha256 x86_64_linux:   "a9e66bf8f967ac410f72b68180343ab44b851eebd473d665eaf771002ace4570"
  end

  keg_only "it conflicts with the Go formula"

  depends_on "go" => :build

  def install
    ENV["GOROOT_BOOTSTRAP"] = Formula["go"].opt_libexec

    cd "src" do
      ENV["GOROOT_FINAL"] = libexec
      system "./make.bash", "--no-clean"
    end

    (buildpath/"pkg/obj").rmtree
    libexec.install Dir["*"]
    bin.install_symlink Dir[libexec/"bin/go*"]

    system bin/"go", "install", "-race", "std"

    # Remove useless files.
    # Breaks patchelf because folder contains weird debug/test files
    Dir.glob(libexec/"**/testdata").each { |testdata| rm_rf testdata }
  end

  test do
    (testpath/"hello.go").write <<~EOS
      package main

      import (
          "fmt"
          _ "crypto/tls/fipsonly"
      )

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
