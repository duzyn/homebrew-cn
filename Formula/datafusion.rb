class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://github.com/apache/arrow-datafusion/archive/refs/tags/15.0.0.tar.gz"
  sha256 "9957592ac28a6bec7d3629a6f2219dbb23c6d715a1a066226a69eeb09f159b32"
  license "Apache-2.0"
  head "https://github.com/apache/arrow-datafusion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16961b03098cf9e402406b1abc8448c12c867bbf5804ac130cf97e66bd4e8c8a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "220d5d230734435ff0e4b91e68ec3a73a9972e0bfaa656fbd67c32eb5374974b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "caf1c0cd8dcd2c0698753677f9a64c4de5564c5eab370a5139226fc6cbdad01c"
    sha256 cellar: :any_skip_relocation, ventura:        "22a20f5d08a8a40a6a000b32c7a6800134fcf438324d67dead66237a96213b28"
    sha256 cellar: :any_skip_relocation, monterey:       "2c40150d4c169e25f31c58ca143086520c80e65d12aa5c1eb3e6e3930ab725c1"
    sha256 cellar: :any_skip_relocation, big_sur:        "8743f6e785e296471736571f909dbc823dbeae0bf1d8f13f5d63406be97e9b2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b712c672172abe1f2f1fca4b4bcd75e893149c6520aca6d8defc863c65ef1bc"
  end

  depends_on "rust" => :build
  # building ballista requires installing rustfmt
  depends_on "rustfmt" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "datafusion-cli")
  end

  test do
    (testpath/"datafusion_test.sql").write("select 1+2 as n;")
    assert_equal "[{\"n\":3}]", shell_output("#{bin}/datafusion-cli -q --format json -f datafusion_test.sql").strip
  end
end
