class Bartycrouch < Formula
  desc "Incrementally update/translate your Strings files"
  homepage "https://github.com/FlineDev/BartyCrouch"
  url "https://github.com/FlineDev/BartyCrouch.git",
      tag:      "4.14.1",
      revision: "6632e30cae5733e04a3d04aaa2afed25c04606a1"
  license "MIT"
  head "https://github.com/FlineDev/BartyCrouch.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "9421271d8884da77f16c587f8e84e599aacefa24e909d95252202fd781230642"
    sha256 cellar: :any, arm64_monterey: "d110fb2436af1d8fee08b80c8225fe8039f9d780e406d15b5b2ae9c1438bcf18"
    sha256 cellar: :any, ventura:        "e6a46387a66389eabfe0d3d0404f8cdf7a1971972f19530d31a33ceae7d40e39"
    sha256 cellar: :any, monterey:       "3e3ec5de221db1d736b4ef1e8e61b7b12c9a72be8638429ddbe9ca3fe1ceacbd"
  end

  depends_on xcode: ["14.0", :build]
  depends_on :macos

  def install
    system "make", "install", "prefix=#{prefix}"

    # lib_InternalSwiftSyntaxParser is taken from Xcode, so it's a universal binary.
    deuniversalize_machos(lib/"lib_InternalSwiftSyntaxParser.dylib")
  end

  test do
    (testpath/"Test.swift").write <<~EOS
      import Foundation

      class Test {
        func test() {
            NSLocalizedString("test", comment: "")
        }
      }
    EOS

    (testpath/"en.lproj/Localizable.strings").write <<~EOS
      /* No comment provided by engineer. */
      "oldKey" = "Some translation";
    EOS

    system bin/"bartycrouch", "update"
    assert_match '"oldKey" = "', File.read("en.lproj/Localizable.strings")
    assert_match '"test" = "', File.read("en.lproj/Localizable.strings")
  end
end
