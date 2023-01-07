class Scalingo < Formula
  desc "CLI for working with Scalingo's PaaS"
  homepage "https://doc.scalingo.com/cli"
  url "https://github.com/Scalingo/cli/archive/1.27.1.tar.gz"
  sha256 "1a3ade5760a1f37b084b5260d19c9f6ebf974bed34b2e9578d7f54a66f98ae55"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4fce8569d36ab00cbe2d6b388b9ee15988b04acdf782100efc02227242cd4fcc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3af168d141b1992635beda2422883f613d6fdbe1121a29df272c9b48beafc157"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "96f6d6b25d6ab28a105b14fb23373f499050b913cbd0d712697355f5fe063bea"
    sha256 cellar: :any_skip_relocation, ventura:        "3d94532fcec338b6f6a87cd926f192158c1da1199112e2bfb51de4fe3455049c"
    sha256 cellar: :any_skip_relocation, monterey:       "191523580ec8b6f1786c5ae41c59abe4aa9a813f6c7311f8bdfb213a8ca897ee"
    sha256 cellar: :any_skip_relocation, big_sur:        "39ace7f22a462b3b8a554ae01f3350cae404f607d2e1a96c24a7c570c9a34c85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "418cfd6f3396b9b5d2905ca127c83ff29fd71664b70ae3abf53baf2b68f72eb9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "scalingo/main.go"
  end

  test do
    expected = <<~END
      +-------------------+-------+
      | CONFIGURATION KEY | VALUE |
      +-------------------+-------+
      | region            |       |
      +-------------------+-------+
    END
    assert_equal expected, shell_output("#{bin}/scalingo config")
  end
end
