class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://mirror.ghproxy.com/https://github.com/dolthub/dolt/archive/refs/tags/v1.43.3.tar.gz"
  sha256 "6fb7d82da3e521a66f181a87bf4cd59d070dafae6d2415677c85557abbedef25"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40b00638b85b6f883cdb8ea1fb861aa05c62b0d3d98f4d98222cdb90fb424e64"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81d8404d0fd3cfe9bc49c49ba3bfc64378cd361b9bb96d8607c7ae8c07849dd8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2410713154dfb0ff09853206db147314e2985e855707819d6ff055e38052e86b"
    sha256 cellar: :any_skip_relocation, sonoma:        "70588d6f15129b9d1458f8d1813eed78c57c060029ea823b9e8062e98c97494b"
    sha256 cellar: :any_skip_relocation, ventura:       "15f0f0d86e8d38b7c5caaa35943b4f3738f8f6a9bceaee83e14bd49634a51e98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2dd73fece6a50367cea0b2af018ccd77bf8d783cf5ff70c7f8060e014f70b4c"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/dolt"
    end
  end

  test do
    ENV["DOLT_ROOT_PATH"] = testpath

    mkdir "state-populations" do
      system bin/"dolt", "init", "--name", "test", "--email", "test"
      system bin/"dolt", "sql", "-q", "create table state_populations ( state varchar(14), primary key (state) )"
      assert_match "state_populations", shell_output("#{bin}/dolt sql -q 'show tables'")
    end
  end
end
