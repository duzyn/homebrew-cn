class Sqlc < Formula
  desc "Generate type safe Go from SQL"
  homepage "https://sqlc.dev/"
  url "https://ghproxy.com/https://github.com/sqlc-dev/sqlc/archive/v1.21.0.tar.gz"
  sha256 "7857578856045e96ecf326c8733a21656025744411f3d151e39c4d3025ed194c"
  license "MIT"
  head "https://github.com/sqlc-dev/sqlc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2945d935c85fcc50c37b0080ad9d09bbc8669d35d5cabb3254f026ce7c92dac0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be41393b33f1f41929921cee8c1bdd69880973a56ee0ac9caa7bb38e6701f532"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6fc78597ffa8287ecc379676eabbd3f8d9674b7a6765e3b7097140556a552ac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2e86baa1b6049a9904222d66389b992d249a6ed36e93962e588ed719f4cb7c80"
    sha256 cellar: :any_skip_relocation, sonoma:         "6a76f0e62954512d9e0afd6a3c25527dd7c5f7d34d60469e4d037f7ce9ec83fc"
    sha256 cellar: :any_skip_relocation, ventura:        "b3e392a3a016d3c220079cb8d81c14c9f1efb0052ed37bcbea4c7f25844d7b06"
    sha256 cellar: :any_skip_relocation, monterey:       "403beb9cc598ffcf7ef5bf16362d655bfe7f7c9400e6cf38871bb5da7ac0cdaa"
    sha256 cellar: :any_skip_relocation, big_sur:        "35562212b84a0e45e1054b514193bf33e4000846fd001851e14f5eb2657aa50c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0b62062fc17ecf577dfc76669a920e1197d72394c6e0855c8e1c41e90d8094e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/sqlc"

    generate_completions_from_executable(bin/"sqlc", "completion")
  end

  test do
    (testpath/"sqlc.json").write <<~SQLC
      {
        "version": "1",
        "packages": [
          {
            "name": "db",
            "path": ".",
            "queries": "query.sql",
            "schema": "query.sql",
            "engine": "postgresql"
          }
        ]
      }
    SQLC

    (testpath/"query.sql").write <<~EOS
      CREATE TABLE foo (bar text);

      -- name: SelectFoo :many
      SELECT * FROM foo;
    EOS

    system bin/"sqlc", "generate"
    assert_predicate testpath/"db.go", :exist?
    assert_predicate testpath/"models.go", :exist?
    assert_match "// Code generated by sqlc. DO NOT EDIT.", File.read(testpath/"query.sql.go")
  end
end
