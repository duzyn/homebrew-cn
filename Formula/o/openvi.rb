class Openvi < Formula
  desc "Portable OpenBSD vi for UNIX systems"
  homepage "https://github.com/johnsonjh/OpenVi#readme"
  url "https://ghproxy.com/https://github.com/johnsonjh/OpenVi/archive/refs/tags/7.4.25.tar.gz"
  sha256 "8a5a870cf6c581dfee519c3631475589620ed7b7cca2c6e015ae1a78094a8292"
  license "BSD-3-Clause"
  head "https://github.com/johnsonjh/OpenVi.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bcd37b67976b49a672087bb78543858208602f1e4db70b2952ecda7ae4832fc7"
    sha256 cellar: :any,                 arm64_ventura:  "0732b6cf42a3a0243ee3a6ece2339e494c9327783345027aef61792582efdfe0"
    sha256 cellar: :any,                 arm64_monterey: "811bfd51687dbaf346eb8dc95ebd73aafe7f6ef0b0ac6b21a9cf2a852514ac61"
    sha256 cellar: :any,                 sonoma:         "18e7d15e432568531c6f16d98f52e41043ca4bc36945a52d3b682a1515d593df"
    sha256 cellar: :any,                 ventura:        "75f5b9f721bd13ca1194b9936fe9211c4380d2bb16954e2e620ac66214fc31ad"
    sha256 cellar: :any,                 monterey:       "15209f1a36a92f149b764d0818694cea0b7b4611b16b9013e6f8407f74452a99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01191395aa14aad8a81b9f1cb8960ebb4b5fb71aaacf66e46566d0ebf5d25ba9"
  end

  depends_on "ncurses" # https://github.com/johnsonjh/OpenVi/issues/32

  def install
    system "make", "install", "CHOWN=true", "LTO=1", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test").write("This is toto!\n")
    pipe_output("#{bin}/ovi -e test", "%s/toto/tutu/g\nwq\n")
    assert_equal "This is tutu!\n", File.read("test")
  end
end
