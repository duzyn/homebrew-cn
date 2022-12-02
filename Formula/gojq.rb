class Gojq < Formula
  desc "Pure Go implementation of jq"
  homepage "https://github.com/itchyny/gojq"
  url "https://github.com/itchyny/gojq.git",
      tag:      "v0.12.10",
      revision: "c1a3ebdcdcdfbdf0f9bf482c9885d53058e6f7a9"
  license "MIT"
  head "https://github.com/itchyny/gojq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c847bcf00e524607595c255e0dbb2f7edc6005f24e1c86f4efe90a8daeec6606"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c847bcf00e524607595c255e0dbb2f7edc6005f24e1c86f4efe90a8daeec6606"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c847bcf00e524607595c255e0dbb2f7edc6005f24e1c86f4efe90a8daeec6606"
    sha256 cellar: :any_skip_relocation, ventura:        "197e9331b6f82b75f8636547bbd7cbf7e430a328b12f9530b40b4700f9430714"
    sha256 cellar: :any_skip_relocation, monterey:       "197e9331b6f82b75f8636547bbd7cbf7e430a328b12f9530b40b4700f9430714"
    sha256 cellar: :any_skip_relocation, big_sur:        "197e9331b6f82b75f8636547bbd7cbf7e430a328b12f9530b40b4700f9430714"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1975ec1b5837d29386d1c41b3979bcca97ef67f7bf3579f149de35e2fd888b91"
  end

  depends_on "go" => :build

  def install
    revision = Utils.git_short_head
    ldflags = %W[
      -s -w
      -X github.com/itchyny/gojq/cli.revision=#{revision}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/gojq"
    zsh_completion.install "_gojq"
  end

  test do
    assert_equal "2\n", pipe_output("#{bin}/gojq .bar", '{"foo":1, "bar":2}')
  end
end
