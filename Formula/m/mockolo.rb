class Mockolo < Formula
  desc "Efficient Mock Generator for Swift"
  homepage "https://github.com/uber/mockolo"
  url "https://mirror.ghproxy.com/https://github.com/uber/mockolo/archive/refs/tags/2.1.1.tar.gz"
  sha256 "6707a0a7b73822f9c6cf986a73a9adc452b3052e38b87169432c0893948861da"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5900b760035156f21faaddbc8a8ffed59f70444d12307e3f98e725801fdfdeef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "75af27726b09a0df48665d7dbe8a28a84c1eb742f50ebfbf9339ed95d18792b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "463d59df9541d099375564265fc22dbee15bbf2dd17291d3eb080685ed427a91"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "006af0dbe99288c6ae3d1f9158d4f9e53200164d73eec4e2ddff909959efb452"
    sha256 cellar: :any_skip_relocation, sonoma:         "5fc054bf963825952b6b816075eee5687a0d9b5c96db29752a21a38bd71c34a2"
    sha256 cellar: :any_skip_relocation, ventura:        "2887686548ea5cdaea1c68071e2f612bc6070d514c314a7cbb10e1298bb96223"
    sha256 cellar: :any_skip_relocation, monterey:       "ae6e8446da621f10ff13da985fcd4ad3faa743275c8290412b1da9191a1b4dc4"
    sha256                               x86_64_linux:   "cc8e52f71953f6b23002b0572060b58849463ab0c5399454012b1173b222cf7a"
  end

  depends_on xcode: ["14.0", :build]

  uses_from_macos "swift"

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox", "--product", "mockolo"
    bin.install ".build/release/mockolo"
  end

  test do
    (testpath/"testfile.swift").write <<~EOS
      /// @mockable
      public protocol Foo {
          var num: Int { get set }
          func bar(arg: Float) -> String
      }
    EOS
    system bin/"mockolo", "-srcs", testpath/"testfile.swift", "-d", testpath/"GeneratedMocks.swift"
    assert_predicate testpath/"GeneratedMocks.swift", :exist?
    output = <<~EOS.gsub(/\s+/, "").strip
      ///
      /// @Generated by Mockolo
      ///
      public class FooMock: Foo {
        public init() { }
        public init(num: Int = 0) {
            self.num = num
        }

        public private(set) var numSetCallCount = 0
        public var num: Int = 0 { didSet { numSetCallCount += 1 } }

        public private(set) var barCallCount = 0
        public var barHandler: ((Float) -> (String))?
        public func bar(arg: Float) -> String {
            barCallCount += 1
            if let barHandler = barHandler {
                return barHandler(arg)
            }
            return ""
        }
      }
    EOS
    assert_equal output, shell_output("cat #{testpath/"GeneratedMocks.swift"}").gsub(/\s+/, "").strip
  end
end
