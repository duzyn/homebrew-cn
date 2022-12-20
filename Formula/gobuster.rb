class Gobuster < Formula
  desc "Directory/file & DNS busting tool written in Go"
  homepage "https://github.com/OJ/gobuster"
  url "https://github.com/OJ/gobuster/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "6c1d7a3aa9604d90ca818d6fc7a0b09501e419ecd4ab7665566c52fd0981b52d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9820b56a0e45217b65115db2e25751c10163c7bce02ca3f055b7096310724b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "074630eaef1913ff05aa15d4d6a76b746398c65edbafe5d41beb9c700f8dd869"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df458e7067fc3dec8b116fe45eb236b7064a2f4eb33e2d23544c29a1b472fde0"
    sha256 cellar: :any_skip_relocation, ventura:        "07df0ac727553adc8718705fa04c6b6116521324f03da1cc92d6260381875603"
    sha256 cellar: :any_skip_relocation, monterey:       "db09e7d44a20593a6dc396f18597728aa3acd854c9284389a2ec141922b1fc30"
    sha256 cellar: :any_skip_relocation, big_sur:        "a784447973cce16026bd9aa06c6136f7541aa29f74100b1888fac7f26664fd49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8dde5b5a125df983e8b0fd80f2a6918ab8554a6a576a4e832bfd3fcd3718f1d1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"gobuster", "completion")
  end

  test do
    (testpath/"words.txt").write <<~EOS
      dog
      cat
      horse
      snake
      ape
    EOS

    output = shell_output("#{bin}/gobuster dir -u https://buffered.io -w words.txt 2>&1")
    assert_match "Finished", output

    assert_match version.major_minor.to_s, shell_output(bin/"gobuster version")
  end
end
