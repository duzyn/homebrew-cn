class Cpuid < Formula
  desc "CPU feature identification for Go"
  homepage "https://github.com/klauspost/cpuid"
  url "https://github.com/klauspost/cpuid/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "bd65882ac77c56cc4a8af5c7c72aa10818ae0b53b9a6928c6d02294e23798344"
  license "MIT"
  head "https://github.com/klauspost/cpuid.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "daa2dfeb9f30d18c5939f07d511f84c433ea066c57a9d552d5675b49005ee66b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "daa2dfeb9f30d18c5939f07d511f84c433ea066c57a9d552d5675b49005ee66b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "daa2dfeb9f30d18c5939f07d511f84c433ea066c57a9d552d5675b49005ee66b"
    sha256 cellar: :any_skip_relocation, ventura:        "677a3cf0da89f7cbf5ca2432b879880f702a4b2588d85a48d0b0a7be36a10b8f"
    sha256 cellar: :any_skip_relocation, monterey:       "677a3cf0da89f7cbf5ca2432b879880f702a4b2588d85a48d0b0a7be36a10b8f"
    sha256 cellar: :any_skip_relocation, big_sur:        "677a3cf0da89f7cbf5ca2432b879880f702a4b2588d85a48d0b0a7be36a10b8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5593f0b8e942f759210c2104dc4aa8796fe569a35fcea7f5eb7193f07a229a21"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cpuid"
  end

  test do
    json = shell_output("#{bin}/cpuid -json")
    assert_match "BrandName", json
    assert_match "VendorID", json
    assert_match "VendorString", json
  end
end
