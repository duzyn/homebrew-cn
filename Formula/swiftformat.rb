class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.50.6.tar.gz"
  sha256 "1ffd7df0835f207487b30f0b53635df02457dc5958f181e8d9c1e2adbad7c698"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a054cd9aae332630cf9d8662b307af25c6374fc59d941b9e9a5baf34630c4de7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d3d211c135b22a540823298d42d43f4f050c239780c487507856b249f1fc5a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "192925e4c50b6a9033afafbc76e3593f98c9910c324a145d25245c2af63145e2"
    sha256 cellar: :any_skip_relocation, ventura:        "09b28c74147e4bda9d2d97b36bc711234c72f0d56416b120af9d9a6d4e23f087"
    sha256 cellar: :any_skip_relocation, monterey:       "9d7b59cc222780b983f4bbbecdee5e3ee4bb7029ae59080873482f708b022f6d"
    sha256 cellar: :any_skip_relocation, big_sur:        "0647e38dfe1c47c7a82abbd7d26a87601a0442852d04ed6eb5566b0e8613fefc"
    sha256                               x86_64_linux:   "94c09bb9768db7bcb16ea68862eec0f544a4e84400d5a691bf4fd15dc20dcbf4"
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
