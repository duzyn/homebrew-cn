class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2023/sqlite-src-3440100.zip"
  version "3.44.0"
  sha256 "52aa53c59ec9be4c28e2d2524676cb2938558f11c2b4c00d8b1a546000453919"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8b1ca17f22a3c9fab3a41f66ab36f524fc917baf64583ec637af4e958c24e415"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "82c8bd338ba4bfe785c4c449a793381fb0f5ff7e69e7f32b948b55ea4a7e4249"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ea5ed02a7b91b553927e8524e073a5ae8b78c8f85acb502a0594b347de8900c"
    sha256 cellar: :any_skip_relocation, sonoma:         "f73412350e5a9ff6f184fc8877865ae42a89a6b0d26bbf8e501dcf20924457c0"
    sha256 cellar: :any_skip_relocation, ventura:        "18279b19c19cd1cc8477412c304c1aaa76f300fb762249f8e97a7e37619f75a6"
    sha256 cellar: :any_skip_relocation, monterey:       "c686be4aeebcd2118ac19dd94f325f4f20d9b716f89b77c76b36329b32a1144d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99fecb65a3b7100676e8a2ad59b5883f7516e9cabffb71a0ea202d7b46a2a120"
  end

  uses_from_macos "sqlite" => :test
  uses_from_macos "tcl-tk"

  def install
    tcl = if OS.mac?
      MacOS.sdk_path/"System/Library/Frameworks/Tcl.framework"
    else
      Formula["tcl-tk"].opt_lib
    end

    system "./configure", "--disable-debug",
                          "--with-tcl=#{tcl}",
                          "--prefix=#{prefix}"
    system "make", "sqlite3_analyzer"
    bin.install "sqlite3_analyzer"
  end

  test do
    dbpath = testpath/"school.sqlite"
    sqlpath = testpath/"school.sql"
    sqlpath.write <<~EOS
      create table students (name text, age integer);
      insert into students (name, age) values ('Bob', 14);
      insert into students (name, age) values ('Sue', 12);
      insert into students (name, age) values ('Tim', 13);
    EOS
    system "sqlite3 #{dbpath} < #{sqlpath}"
    system bin/"sqlite3_analyzer", dbpath
  end
end
