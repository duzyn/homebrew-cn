class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://mirror.ghproxy.com/https://github.com/direnv/direnv/archive/refs/tags/v2.37.1.tar.gz"
  sha256 "4142fbb661f3218913fac08d327c415e87b3e66bd0953185294ff8f3228ead24"
  license "MIT"
  head "https://github.com/direnv/direnv.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "d9a33db5762df07167bb6a532c54b84a9f99fe5730b0aedc83b300534c7e8f3e"
    sha256 arm64_sonoma:  "494117574d9df4de6ffa3f123cfe0a1626e2d5ba0542a25e85dee6b0814417b8"
    sha256 arm64_ventura: "968f2dd705d3a3223377b556f459c5c65db53a8fa6435a37ce84f27fbb5ed18c"
    sha256 sonoma:        "9b274c4ce7351773cd91a9418a2aeb16c72ed5685383a9ea97269c24b81c1c86"
    sha256 ventura:       "7754bbca76a16a6737177ea057d4db9c2ad1e55387b9f3ff5aafe05912807008"
    sha256 x86_64_linux:  "5a3705773719544d8c366610498528d6607de6a2961b2ecb1cdedb5781b9d1c6"
  end

  depends_on "go" => :build
  depends_on "bash"

  def install
    system "make", "install", "PREFIX=#{prefix}", "BASH_PATH=#{Formula["bash"].opt_bin}/bash"
  end

  test do
    system bin/"direnv", "status"
  end
end
