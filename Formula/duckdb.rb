class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/duckdb/duckdb.git",
      tag:      "v0.6.1",
      revision: "919cad22e8090087ae33625661f26a5fc78d188b"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "850a6d47aff870828513ee176e1f8132f76a4f533cf641cb32a942c4731dc770"
    sha256 cellar: :any,                 arm64_monterey: "fd8791cb44e2261565dbe9cad94c1894134703ab430be64df06325c55c768414"
    sha256 cellar: :any,                 arm64_big_sur:  "5f8b7c1746c9efbadc9858db48c7cb6b7fc86e09fdd4502389f15605d379abee"
    sha256 cellar: :any,                 ventura:        "f8ec3cf2dc4bfe6fce10f7acbdb8a28ef1f7c43c53b11011904fb7dca2adc4f7"
    sha256 cellar: :any,                 monterey:       "d44430150352cbc82d661818c7a46484f78e9dae0532430149eec2042f716ff9"
    sha256 cellar: :any,                 big_sur:        "b66ff299905039374bb6fb2f685f9691f22aafbf23b45aef3b7614bd0b65f46b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c6fe2bdcc79e08538d07c204627217eb2f952e1d7db471645280e6f8e54e1d0"
  end

  depends_on "cmake" => :build

  def install
    mkdir "build"
    cd "build" do
      system "cmake", "..", *std_cmake_args, "-DBUILD_ICU_EXTENSION=1", "-DBUILD_JSON_EXTENSION=1",
             "-DBUILD_PARQUET_EXTENSION=1"
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
