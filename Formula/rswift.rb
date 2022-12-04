class Rswift < Formula
  desc "Get strong typed, autocompleted resources like images, fonts and segues"
  homepage "https://github.com/mac-cain13/R.swift"
  url "https://ghproxy.com/github.com/mac-cain13/R.swift/releases/download/7.1.0/rswift-7.1.0-source.tar.gz"
  sha256 "1f9aac2075f94a384b7293cf64db39c5d522847122b2efc3bbda6a33e12b9d98"
  license "MIT"
  head "https://github.com/mac-cain13/R.swift.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f2ddbf7ac4cfe913a4dd74ab971e04fdf18d7221c8bf45b583efab6bb0669546"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5dcb76afcfe70d5452b1ec8507e1cbae48b7e571406d31c95e2a55362810685"
    sha256 cellar: :any_skip_relocation, ventura:        "964b149d215719ad37bcb03334b430bbc811999704c7ef03c7e25c1064d611b4"
    sha256 cellar: :any_skip_relocation, monterey:       "7f3a91a5d8bb25095ce8fa9917a0f7b32d15afe0ed857ac1a36e396ad18939a2"
  end

  depends_on :macos # needs CoreGraphics, a macOS-only library
  depends_on xcode: "13.3"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/rswift"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rswift --version")
    expected_output="Error: Missing argument PROJECT_FILE_PATH"
    assert_match expected_output, shell_output("#{bin}/rswift generate #{testpath} 2>&1", 64)
  end
end
