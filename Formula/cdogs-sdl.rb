class CdogsSdl < Formula
  desc "Classic overhead run-and-gun game"
  homepage "https://cxong.github.io/cdogs-sdl/"
  url "https://github.com/cxong/cdogs-sdl/archive/1.4.0.tar.gz"
  sha256 "4030bd8f6168b8f7ee152d0edb1d7a4b75920b7b7fb19a2f7e834508af9631cd"
  license "GPL-2.0-or-later"
  head "https://github.com/cxong/cdogs-sdl.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "7ab0ae93df0826b23c9faa7c648571323348e6b2f96bfa2ed2edf06d2c883b39"
    sha256 arm64_monterey: "60dd211d42fe2ad6be5757bb6b1d1665a52f6c6f54288abe4f853e6f65b0b812"
    sha256 arm64_big_sur:  "e7cb4737f8ec5b6255b3a05fcfd83a19fa7a9782bbacafcadea2544171beaa36"
    sha256 ventura:        "b4013be241898d9468b41a0cedc654bdc940c127079f1ed2cca083172a20afee"
    sha256 monterey:       "15781381795e069a47903ed11e710f042d28df2ad71680f40006e5d02c562d43"
    sha256 big_sur:        "8d5a941a72e47c8d3632a28a76668e6802e79d147a65615fcc5cb9352889dbe2"
    sha256 x86_64_linux:   "862dc537b6cf94e289c6a2f5b65f87b6d67c0abc85303cd569bf997cfb12e120"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "protobuf" => :build
  depends_on "python@3.11"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"

  on_linux do
    depends_on "glib"
    depends_on "gtk+3"
    depends_on "mesa"
  end

  def install
    args = std_cmake_args
    args << "-DCDOGS_DATA_DIR=#{pkgshare}/"
    system "cmake", ".", *args
    system "make"
    bin.install %w[src/cdogs-sdl src/cdogs-sdl-editor]
    pkgshare.install %w[data dogfights graphics missions music sounds]
    doc.install Dir["doc/*"]
  end

  test do
    pid = fork do
      exec bin/"cdogs-sdl"
    end
    sleep 7
    assert_predicate testpath/".config/cdogs-sdl",
                     :exist?, "User config directory should exist"
  ensure
    Process.kill("TERM", pid)
  end
end
