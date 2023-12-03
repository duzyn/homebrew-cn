class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://mirror.ghproxy.com/https://github.com/kimono-koans/httm/archive/refs/tags/0.32.1.tar.gz"
  sha256 "ad16f36bc09aab25d7b96d3cc60e6a2d2eb7ff6de9290d5ce72ae146083b336d"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "600080c118b3533237e8d92e98e6aaa4b53c25100a1a92ac02135386112ae0f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb6b8787e53c566c9fecc3ea217db6ef5dcb1315907d52e75333bc80bcd54b63"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b06c0bf0eaa46c6f9fd8ee4484cd9ed2f4012c375578ef3b8ef8b3802f75b42"
    sha256 cellar: :any_skip_relocation, sonoma:         "6218a768182a9924d9887a7761bd8ec44d3a616222cd83514afc084ba64bae90"
    sha256 cellar: :any_skip_relocation, ventura:        "ae85acb131f002c29f661ba0d87719441783a94cb895d507a988d9c16c687ab6"
    sha256 cellar: :any_skip_relocation, monterey:       "cc5d8b7d3804f79a28256d1e4ca44c95547615d867299cf1b4d19006bda6dda9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca0db2aea5fdab25a5c5d35242756e197b5abc8a8243e398f6bf57fbbd913f93"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "httm.1"
  end

  test do
    touch testpath/"foo"
    assert_equal "Error: httm could not find any valid datasets on the system.",
      shell_output("#{bin}/httm #{testpath}/foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}/httm --version").strip
  end
end
