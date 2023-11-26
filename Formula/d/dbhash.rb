class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://www.sqlite.org/2023/sqlite-src-3440100.zip"
  version "3.44.0"
  sha256 "52aa53c59ec9be4c28e2d2524676cb2938558f11c2b4c00d8b1a546000453919"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d3d20f259631cd7333bb6dc091c5cc32cc1d89129709c13c96cd179a41e21940"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c081069f31e3d32bf7be811d3148ea44e517504d525a40d5e308c9a7ae38f898"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41add89d5aea0bae8992607e17e91bca9d20f46b09d6bcf9c515762640ecd220"
    sha256 cellar: :any_skip_relocation, sonoma:         "179a3c875060e1613e59899a0e01bd955c5520265bf55bc1e1ce35a3e1658457"
    sha256 cellar: :any_skip_relocation, ventura:        "219aab8d16a578221477727be53659c8f5f960b244d642494580ded41590c768"
    sha256 cellar: :any_skip_relocation, monterey:       "770b1852b11079656884925abd9107dc6644dd99309cf30fbed5b1e4f64311f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7826dbf3982a9fb4d81943879009ce6f7fac80ba34601136dc6afde39aa6174"
  end

  uses_from_macos "tcl-tk" => :build
  uses_from_macos "sqlite" => :test

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make", "dbhash"
    bin.install "dbhash"
  end

  test do
    dbpath = testpath/"test.sqlite"
    sqlpath = testpath/"test.sql"
    sqlpath.write "create table test (name text);"
    system "sqlite3 #{dbpath} < #{sqlpath}"
    assert_equal "b6113e0ce62c5f5ca5c9f229393345ce812b7309",
                 shell_output("#{bin}/dbhash #{dbpath}").strip.split.first
  end
end
