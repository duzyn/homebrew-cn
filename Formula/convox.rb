class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.10.2.tar.gz"
  sha256 "021163f6eea84c298d94bcbea5ee760a593b4c8a0ba870b03c4911be78cf4d5a"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4131138a42e78c704e41ff94192829cf67ff9ee67a6021974a65f752c5c2d7f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3fc01e4eea7148415f29934a42db83c0d62f8e38ff86fb3580845a5823093080"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c026a57fa921f3983141827411ed3859b368d2277fe7bc938472fc5529f488e4"
    sha256 cellar: :any_skip_relocation, ventura:        "7fffd922df89c14e1c3b59cbfa593146a8c6aab6ef80821a906a95784c6d0172"
    sha256 cellar: :any_skip_relocation, monterey:       "9198798d728f7a0a32cddbcaf1c5ebff52841621505a9e68dc67ac7911189ae1"
    sha256 cellar: :any_skip_relocation, big_sur:        "cb3cb5d62ad3180685768f4be08168d24801fbf4298fb45cc9d258e972206df8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "132a9097b1ca1a3d767441081c7802bc06053e6a6d7d23b9d91ee54986c91172"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]

    system "go", "build", "-mod=readonly", *std_go_args(ldflags: ldflags), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
