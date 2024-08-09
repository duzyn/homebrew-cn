class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://mirror.ghproxy.com/https://github.com/dolthub/dolt/archive/refs/tags/v1.42.9.tar.gz"
  sha256 "acac49e50017b1d687bb34bc0a59c81d5b744a742969851bf4ffe8620608fb83"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fcf469eb0381117bb62baaeef0e243c0489adffd8c4c85bcbba7b626570d5371"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "21190f350b92c14be4ba38c6055352b8d61135cf0fadbd7e3ff6adf7a3746fb9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "784c13e8bf7a956aa35947bd3a4504544ccfc8e0e1ba120f8d3fdd153457a9fa"
    sha256 cellar: :any_skip_relocation, sonoma:         "53d9db917e9121650d371356f4597f53db19e8807cabef1fdcb653dc10f4c5da"
    sha256 cellar: :any_skip_relocation, ventura:        "ff6cd6c5fb4341d44567a408601eea336310c0cc075d9809ee1336921110f421"
    sha256 cellar: :any_skip_relocation, monterey:       "781a1b2c35186de65df49d64bebbdb5c125cf172941019ea182f4c5e19de8af9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0fed84ceef74b7bd7d48aec30f0f5498150e48e636a2ce68c3606fb9a331620"
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
