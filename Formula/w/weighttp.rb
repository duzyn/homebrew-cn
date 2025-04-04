class Weighttp < Formula
  desc "Webserver benchmarking tool that supports multithreading"
  homepage "https://redmine.lighttpd.net/projects/weighttp/wiki"
  url "https://mirror.ghproxy.com/https://github.com/lighttpd/weighttp/archive/refs/tags/weighttp-0.4.tar.gz"
  sha256 "b4954f2a1eca118260ffd503a8e3504dd32942e2e61d0fa18ccb6b8166594447"
  license "MIT"
  head "https://git.lighttpd.net/lighttpd/weighttp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "55b511aee9ca33b3136e4c06d1fe7c83e5b9edc06b4d8a00d6b9228f0c61ca6f"
    sha256 cellar: :any,                 arm64_sonoma:   "8ef536a1d1625b63bd6fb92bc1980ff152c52e5598e308412f224cfd1d5b5a8d"
    sha256 cellar: :any,                 arm64_ventura:  "21eca9535f85701e10a816f1841397c2a8bd7792503dfcec9c5a1f3a07121d6b"
    sha256 cellar: :any,                 arm64_monterey: "64057edc2b2ff52e19975c6fadcc94bb456b4a37ad0a3e7f94b93b7477cdc867"
    sha256 cellar: :any,                 arm64_big_sur:  "61bd26ebdcd743d1078d4bd2138f55bcd943900c85acf567ccfda9fe4fc89379"
    sha256 cellar: :any,                 sonoma:         "8a7cd2b59587829920b7eda66607f7546371d569f0567bd74f619417b6245620"
    sha256 cellar: :any,                 ventura:        "21435b447ad202da969ce1132061ec141e73dd0e62b7f92a8298f67e7c37eb35"
    sha256 cellar: :any,                 monterey:       "6c94e449d1376949e49017b614bd578d297f64b59738e4a0616667d6f2f8892d"
    sha256 cellar: :any,                 big_sur:        "73c147309603c830719feac16847dc9ec2f09d27dc3a3f702760efe1eaaf8405"
    sha256 cellar: :any,                 catalina:       "b76ee9060b8cb86897af45c620b1f1fb3d757955a2a2f8e4c55ef6a153bfc547"
    sha256 cellar: :any,                 mojave:         "2ab4f5e31f9411d55c4a4653f78bb381b70f53f49d07efaf6e99b5a86281b62a"
    sha256 cellar: :any,                 high_sierra:    "4225f653fe64067e3330c33202a15ad65a6b194ce23619ae045cbe50528a9b02"
    sha256 cellar: :any,                 sierra:         "242f14d7a7fb477e4722a3818a98ad25ffedd5d2c80e7c97d67c80fe2a20366c"
    sha256 cellar: :any,                 el_capitan:     "e96be0135f552ddde0547ca914c2bc6635dcc59ce4bdeb803ab9412100d8d15b"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "bb0635cbcb87b8e145d88c1992eda333d22f4369bfaf14589dcb74239763b5b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7ef5cfd2cdadf8036c30295d3c51a56399d8acee7e2dc96aa1d75d471e2c1a0"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libev"

  def install
    system "autoupdate"
    system "./autogen.sh"
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    # Stick with HTTP to avoid 'error: no ssl support yet'
    system bin/"weighttp", "-n", "1", "http://redmine.lighttpd.net/projects/weighttp/wiki"
  end
end
