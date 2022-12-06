class Ctlptl < Formula
  desc "Making local Kubernetes clusters fun and easy to set up"
  homepage "https://github.com/tilt-dev/ctlptl"
  url "https://github.com/tilt-dev/ctlptl/archive/v0.8.14.tar.gz"
  sha256 "b4bf725e9d426ec47eaa27c892739c8af6e427313608db6a966635e920ef600d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c2bd57192c985ca3f0fe091ac612855265f888154784da870fb569cd22a2b19"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8bf8c6ebf4045e396520c2bcee8b97a9b435781dd58b15c2e9a93d9044964215"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "33dabb0f6bf7076204e0aff4d59c1f5f7ca3c851661dd3bd3afb546a9521dd76"
    sha256 cellar: :any_skip_relocation, ventura:        "d29386486f6db541f8ba120309458e2452838cda6eac9cf80b0d047798484d1e"
    sha256 cellar: :any_skip_relocation, monterey:       "2a7780fbe2bf87ff24f008246872626ddf30675ad01f86136e251b45bf780db7"
    sha256 cellar: :any_skip_relocation, big_sur:        "aee1ee1ebab58651aaac716ab315cf7ce1d5478c657641e104d6e96fe8e61b1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6af98a26b5991fc837bfbf687bcf3d348f77003a51040808675b8b441b2d3706"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/ctlptl"

    generate_completions_from_executable(bin/"ctlptl", "completion")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/ctlptl version")
    assert_equal "", shell_output("#{bin}/ctlptl get")
    assert_match "not found", shell_output("#{bin}/ctlptl delete cluster nonexistent 2>&1", 1)
  end
end
