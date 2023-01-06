class Scalingo < Formula
  desc "CLI for working with Scalingo's PaaS"
  homepage "https://doc.scalingo.com/cli"
  url "https://github.com/Scalingo/cli/archive/1.27.0.tar.gz"
  sha256 "8be8e132a1febb0f0dc7f9d1290e99177f1a557eb03b76d3b93a9f0d51fec271"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b9bc3514562d7e3f35bb20330c3cb4b9811b29499836ceea7732929c7c78794"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bea4418dc1770e2ea4489b321379156d18556944eb9c3115ad13ee52ae705d5f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4ca93c2ac621f79b92e6615a13ced0512c52c29cfe641503e7fbe21f0dc7ca18"
    sha256 cellar: :any_skip_relocation, ventura:        "b9315d08f5a07cca057a58c84fab4dff21bf64aae659a066ee9aa9b833e1ae52"
    sha256 cellar: :any_skip_relocation, monterey:       "1da28985c8c83d5d17d66b7a0ddaec120d172c1584202c55d324174009c67b67"
    sha256 cellar: :any_skip_relocation, big_sur:        "d1ecf3644d8c12ceb7bc9be4087faf740de6cd7239d3a174b2230e9304c9b762"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f780a4fea0643a63a3081c191bc4153cf6f86ff0cefba4b2f7f09c2ca41aeb35"
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
