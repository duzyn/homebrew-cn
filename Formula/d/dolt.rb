class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://mirror.ghproxy.com/https://github.com/dolthub/dolt/archive/refs/tags/v1.36.1.tar.gz"
  sha256 "8f242ba393a393508665045900f15dae6c61c1dac2365d574ae41ce48ae98726"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "41d86f59c70fda256fe484240fc26e82f935fbdd89b1f1be8bd4678f92b5fa12"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "830d13afe7782d43a88167b01d3d858d24f4151eebec20598718696ef5eadd76"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6aa9bb17576dca3d122f7e768b1e3a23134257effe2ff289eae603663bdf1f47"
    sha256 cellar: :any_skip_relocation, sonoma:         "3f026231445f5f4e44b184b41dddaf84d84a17020e817ae1924e0da8368098a6"
    sha256 cellar: :any_skip_relocation, ventura:        "402aabb929e7b66fbd03410148d60d3960610e949ea70e50002652d08d95ffbf"
    sha256 cellar: :any_skip_relocation, monterey:       "67406e9305399c80429501b9e40dc9355326a38ecedd78578c1fb7e8a1689469"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "578f27d7aded69a51e8e52732bd5bd5dafc6da4f74d6635f9d7ec3c90bf006e5"
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
