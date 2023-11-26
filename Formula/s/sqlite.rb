class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/index.html"
  url "https://www.sqlite.org/2023/sqlite-autoconf-3440100.tar.gz"
  version "3.44.0"
  sha256 "63c3181633844adb5e36187f75b8f31a51cd32487992a26b89bf26b22ecdcf48"
  license "blessing"

  livecheck do
    url :homepage
    regex(%r{href=.*?releaselog/v?(\d+(?:[._]\d+)+)\.html}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub("_", ".") }
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "fa132db79fe888d31b4d4cddf4fc6ad9ef4010d21ac57464cf389fe504989a12"
    sha256 cellar: :any,                 arm64_ventura:  "9bf78ea015b6910175f71e2367e60f59ea5b66b7081648a8d1fad5b662c83afa"
    sha256 cellar: :any,                 arm64_monterey: "ed2265541a05ac1268b2d643f0622766ba53600cc81d7ca1ce588132f2fa5bfe"
    sha256 cellar: :any,                 sonoma:         "ad64a2c04fe1d60ada4de8ebebb3428755b70507188909d0c91de417ff4a80b1"
    sha256 cellar: :any,                 ventura:        "9dfa089ca3a3b9c0187cfce6964526366c1b76fb42980419dcb26020a874acee"
    sha256 cellar: :any,                 monterey:       "de19a9b4e4b3c1138e093f82d9f5f3db6990896192dc126c9b96903dfcffddd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54775b760e63628adcb0bd7edfffacee6220268efb3123cf5fd831aa5b3da42a"
  end

  keg_only :provided_by_macos

  depends_on "readline"

  uses_from_macos "zlib"

  def install
    # Default value of MAX_VARIABLE_NUMBER is 999 which is too low for many
    # applications. Set to 250000 (Same value used in Debian and Ubuntu).
    ENV.append "CPPFLAGS", %w[
      -DSQLITE_ENABLE_API_ARMOR=1
      -DSQLITE_ENABLE_COLUMN_METADATA=1
      -DSQLITE_ENABLE_DBSTAT_VTAB=1
      -DSQLITE_ENABLE_FTS3=1
      -DSQLITE_ENABLE_FTS3_PARENTHESIS=1
      -DSQLITE_ENABLE_FTS5=1
      -DSQLITE_ENABLE_JSON1=1
      -DSQLITE_ENABLE_MEMORY_MANAGEMENT=1
      -DSQLITE_ENABLE_RTREE=1
      -DSQLITE_ENABLE_STAT4=1
      -DSQLITE_ENABLE_UNLOCK_NOTIFY=1
      -DSQLITE_MAX_VARIABLE_NUMBER=250000
      -DSQLITE_USE_URI=1
    ].join(" ")

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --enable-dynamic-extensions
      --enable-readline
      --disable-editline
      --enable-session
    ]

    system "./configure", *args
    system "make", "install"

    # Avoid rebuilds of dependants that hardcode this path.
    inreplace lib/"pkgconfig/sqlite3.pc", prefix, opt_prefix
  end

  test do
    path = testpath/"school.sql"
    path.write <<~EOS
      create table students (name text, age integer);
      insert into students (name, age) values ('Bob', 14);
      insert into students (name, age) values ('Sue', 12);
      insert into students (name, age) values ('Tim', 13);
      select name from students order by age asc;
    EOS

    names = shell_output("#{bin}/sqlite3 < #{path}").strip.split("\n")
    assert_equal %w[Sue Tim Bob], names
  end
end
