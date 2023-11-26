class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://www.sqlite.org/2023/sqlite-src-3440100.zip"
  version "3.44.0"
  sha256 "52aa53c59ec9be4c28e2d2524676cb2938558f11c2b4c00d8b1a546000453919"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f6a9a6da7babc5907e7092b024ad0522e2338564a8b6ef27ceda1c75e0999a5f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b0d9cd7c5f4c71905f642f9029bbf71a4d7e9619a3ec19eb8826c2ffdab883d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1dff023e982a775b2e6e3fc261ff638b6da7f1a6fd736eed0bcde4ec07e94180"
    sha256 cellar: :any_skip_relocation, sonoma:         "a46c21059c6d160092bd0e6abc51f68cc5a85df047809c0e8741ecfb016d4046"
    sha256 cellar: :any_skip_relocation, ventura:        "24445c7768522e446cf6e0b07b160d03b941cc20191a32c3da81ac8624228258"
    sha256 cellar: :any_skip_relocation, monterey:       "435840f2fc33cca60c18feb831f5a922d0a92dd27b404d946c006048e1eaa5df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db6b084e1eafc4278a0298ec0cb9a0ede702b53081f0a0ec3b114dec286b9e41"
  end

  uses_from_macos "tcl-tk" => :build
  uses_from_macos "sqlite" => :test

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make", "sqldiff"
    bin.install "sqldiff"
  end

  test do
    dbpath = testpath/"test.sqlite"
    sqlpath = testpath/"test.sql"
    sqlpath.write "create table test (name text);"
    system "sqlite3 #{dbpath} < #{sqlpath}"
    assert_equal "test: 0 changes, 0 inserts, 0 deletes, 0 unchanged",
                 shell_output("#{bin}/sqldiff --summary #{dbpath} #{dbpath}").strip
  end
end
