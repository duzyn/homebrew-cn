class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://mirror.ghproxy.com/https://github.com/dolthub/dolt/archive/refs/tags/v1.40.1.tar.gz"
  sha256 "8c063e873ddfb1de3071a581f1bf66be394d56bea602c9135b19855143eb4a23"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7b299e04a62ef74092eda89c036d91c17b5ebf681cce2f4a3cf945980d56fe4b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c539631f870b15f7efbe41665750f51ad51090f746060fe5a86cd39a0e4d3fc5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "182d185cc56d5d43d35bf5d178c7f38696dc59d96d15184205fa7855e84cda27"
    sha256 cellar: :any_skip_relocation, sonoma:         "98d61d6546ced03f33a9c79918d89811ab1a699bd8e575952279407255160652"
    sha256 cellar: :any_skip_relocation, ventura:        "e326ffc645633dc14c44ec0e19abf524d26cb0f2e9bbff5df0798381a99cf30f"
    sha256 cellar: :any_skip_relocation, monterey:       "0d741e17f97dc4bad80345fe8896a228f54ba38c16ef9ed5a6f32a6f7809adcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5081d64262ded81e038225eb0ed746c5a354399df044e654a9e0891474e8ec98"
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
