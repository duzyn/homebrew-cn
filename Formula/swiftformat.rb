class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://ghproxy.com/https://github.com/nicklockwood/SwiftFormat/archive/0.51.14.tar.gz"
  sha256 "4018889ea04b709c5b0ab9650eeeee52152964b46baa72dea716cfa8985fd4ad"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f63b488fde02bc7e36503c0d50a4b96951edd760d2c77c5da585ac1b720fba86"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14aefec06bbcce8689341682c4cbb94b1596692bd6200f8bc22536fa382dceb4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b6d635a4ffa1ae9ba45ba07cd793058794ad7f3bcda4e7c16d7f7c1faef56727"
    sha256 cellar: :any_skip_relocation, ventura:        "d884fa4c38b67bf6c90a2b2dc7c2d8704cb12dec06f9e163d3b087def5c5848c"
    sha256 cellar: :any_skip_relocation, monterey:       "7526769f7482441d6aad3361e4ed761df14f0ca15a291ca61a16ffa77dd95450"
    sha256 cellar: :any_skip_relocation, big_sur:        "97260ddb3cc6619ed3d9b5ac8bee33e87bef9756a9672d1a4f12da87032d190d"
    sha256                               x86_64_linux:   "136b0aed419a7a169eb35136a4f31a6b460b6b9bd32ccc7246afe297a29dbc7c"
  end

  depends_on xcode: ["10.1", :build]

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/swiftformat"
  end

  test do
    (testpath/"potato.swift").write <<~EOS
      struct Potato {
        let baked: Bool
      }
    EOS
    system "#{bin}/swiftformat", "#{testpath}/potato.swift"
  end
end
