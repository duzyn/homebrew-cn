class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://mirror.ghproxy.com/https://github.com/dolthub/dolt/archive/refs/tags/v1.39.0.tar.gz"
  sha256 "d412c4a9616cf6fe5df85a2782ab5127f20d4dad35c79cc0fa765d6c2d8c88ac"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "44980e5de01c92a6ad8452bd51ced06167cb708ffd4b55db3a20ec950d8edf3c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7bf588e0da5fa874fcfa37a38b5a4691cb316d56932fb3b98337cc071556541c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae88be4d1e97af206a1a22b40d2affcc53c240b326de5dfac2ea2f8b587b1f68"
    sha256 cellar: :any_skip_relocation, sonoma:         "03edde6ee8aa64be4a2e318063e9b5daa6de0c2afc8ce613073ac99fd9af69a8"
    sha256 cellar: :any_skip_relocation, ventura:        "a4d281ef9f3a4493065d52214a9b970df130fae858b8c1cb7fab7250c9410e72"
    sha256 cellar: :any_skip_relocation, monterey:       "85e9e4e099a8b121cb0df8f629cd704328c67812fd84f063ebc5e816a89bfe61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1e59e2173e27f49fa2ef8cc308adf030cf28e525e3ee6a12efdf68711e83393"
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
