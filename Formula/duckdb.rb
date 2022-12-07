class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/duckdb/duckdb.git",
      tag:      "v0.6.1",
      revision: "919cad22e8090087ae33625661f26a5fc78d188b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f04816e93e6beaedb8181a3b56eaf3a9896540e5a2f69de9447eb9042f8148e9"
    sha256 cellar: :any,                 arm64_monterey: "59c7ba61892ae55255c72c5be0753b0ce8d618f0b7c66a5994e757c0e5f90d5d"
    sha256 cellar: :any,                 arm64_big_sur:  "00a4cdabbfa3a66d5255c62b063358c0fb54cbae0365d00c7f9c0d97d60d9ba4"
    sha256 cellar: :any,                 ventura:        "ee18a8a94d21bb9521a553683e09a868879a4477836d10afd27fd6768d94afc0"
    sha256 cellar: :any,                 monterey:       "427077f959add9d23f75e2a01ad19d31024162958b2b3a3d76a94932bc283ec3"
    sha256 cellar: :any,                 big_sur:        "690498b4d19dc171ecaa5dd469c5b3ba24fbdb833b6c4b7b769c83fd73518d32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a66be4e86280eff90ffedacc07d4842d80f6b8d7f3d8edc294b4a4e466dd3b87"
  end

  depends_on "cmake" => :build
  depends_on "python@3.11" => :build

  def install
    ENV.deparallelize if OS.linux? # amalgamation builds take GBs of RAM
    mkdir "build/amalgamation"
    python3 = "python3.11"
    system python3, "scripts/amalgamation.py", "--extended"
    system python3, "scripts/parquet_amalgamation.py"
    cd "src/amalgamation" do
      system "cmake", "../..", *std_cmake_args
      system "make"
      system "make", "install"
      bin.install "duckdb"
      # The cli tool was renamed (0.1.8 -> 0.1.9)
      # Create a symlink to not break compatibility
      bin.install_symlink bin/"duckdb" => "duckdb_cli"
    end
  end

  test do
    path = testpath/"weather.sql"
    path.write <<~EOS
      CREATE TABLE weather (temp INTEGER);
      INSERT INTO weather (temp) VALUES (40), (45), (50);
      SELECT AVG(temp) FROM weather;
    EOS

    expected_output = <<~EOS
      ┌─────────────┐
      │ avg("temp") │
      │   double    │
      ├─────────────┤
      │        45.0 │
      └─────────────┘
    EOS

    assert_equal expected_output, shell_output("#{bin}/duckdb_cli < #{path}")
  end
end
