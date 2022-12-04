class Dronedb < Formula
  desc "Free and open source software for aerial data storage"
  homepage "https://github.com/DroneDB/DroneDB"
  url "https://github.com/DroneDB/DroneDB.git",
       tag:      "v1.0.11",
       revision: "f9f7d50c1f2b49072e4046cb2bd2d9fd67066252"
  license "MPL-2.0"
  revision 2
  head "https://github.com/DroneDB/DroneDB.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "614515429ab8ee347d308e0bbba59a5fb08e177cdd597fe7fe189dcfa58440b6"
    sha256 cellar: :any, arm64_monterey: "b91ea081e4c0774531a8ca8d1d88bd82a4404570d8d625110af43ce45346a528"
    sha256 cellar: :any, arm64_big_sur:  "0fcd3b18148f42ae8d074e4ad61f37821e490f14aae8721533a3f29aca14bc53"
    sha256 cellar: :any, ventura:        "edfa14caba8e665ce09375d9a745ebd06de430e9bbac9ef35ba71c8688023d40"
    sha256 cellar: :any, monterey:       "ccde7aecb9845e9743e6412dd66d7e8ec369a131aad81e77ef7d404c0738b424"
    sha256 cellar: :any, big_sur:        "0a35a8ab3360a95e42578ce5b86292c04ceef290ed7c1f80c4e218ffcb8087d3"
  end

  depends_on "cmake" => :build
  depends_on "gdal"
  depends_on "libspatialite"
  depends_on "libzip"
  depends_on "pdal"

  def install
    # Avoid installing conflicting vendored libraries into Homebrew's prefix.
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args(install_prefix: libexec)
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    bin.install_symlink libexec/"bin/ddb"
  end

  test do
    system "#{bin}/ddb", "--version"
    system "#{bin}/ddb", "info", "."
    system "#{bin}/ddb", "init"
    assert_predicate testpath/".ddb/dbase.sqlite", :exist?
  end
end
