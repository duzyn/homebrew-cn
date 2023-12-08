class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://mirror.ghproxy.com/https://github.com/dolthub/dolt/archive/refs/tags/v1.29.2.tar.gz"
  sha256 "062f57401bf02336b478500a2c2847291c7b071159a198458e087ba1d019c968"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a4419f6ff209b93a88037ce101d3adfa95d6e7ec7e448f48702f93b658456283"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "48fa937d22cfd58ff1289874bcd3e40124916cc2e641ad849d852c95c704432e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2170c39bd2febc826b7927da52c81a3a1d41e89a95616c2b49578027096c25cc"
    sha256 cellar: :any_skip_relocation, sonoma:         "3e8ff3e5c269e40f86d0ecf23c0399f85d1a14868edadb8d924ab0fb50b5bfc0"
    sha256 cellar: :any_skip_relocation, ventura:        "3603118c62fed511086183a82c5ec15c7328807c77533fcc93cf298ca7315b3c"
    sha256 cellar: :any_skip_relocation, monterey:       "087e511739702e88dd90cf934d4ffa991ef5c6fd580659d100d735652969c313"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10ccf8b4d3ab0e85263510703b54f2689202d0685ecdf5754d844144d6c1cd41"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args, "./cmd/dolt"
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
