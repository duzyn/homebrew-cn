class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mmctl"
  url "https://github.com/mattermost/mmctl.git",
      tag:      "v7.5.2",
      revision: "1fffa8a8295256fb8b39d66ed7083269e54cb4d5"
  license "Apache-2.0"
  head "https://github.com/mattermost/mmctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70e19e3810cd356d66da1480de2be2a316c31e50e6462ee38a68aeb375a5cd15"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7eea9c153886accc2a3cb0b8720d51e5b0bd01848b1f6ba4dfdf6c63ea68ecd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2b9e49ba5dd677eaa2f6accab47f12f363d3cc0c37b6616c8db398c2dca9df41"
    sha256 cellar: :any_skip_relocation, ventura:        "014c4acb9e93b40765f1ef47815a57e83cb1a0a1288328c7f5b30b82da6bbbbf"
    sha256 cellar: :any_skip_relocation, monterey:       "6432fb6bddbbf7f1547d535f67eb0344838517042bc65f549cd186f721c70c23"
    sha256 cellar: :any_skip_relocation, big_sur:        "e27def1443e4c4f214d0b18b6af2983fc2c5ec3dd14f6a24abd903a77131c332"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1eb53d450273cb444e54614e22868261b9b59d7587b8116b546bc8472c43b75"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/mattermost/mmctl/commands.BuildHash=#{Utils.git_head}"
    system "go", "build", *std_go_args(ldflags: ldflags), "-mod=vendor"

    # Install shell completions
    generate_completions_from_executable(bin/"mmctl", "completion", shells: [:bash, :zsh])
  end

  test do
    output = pipe_output("#{bin}/mmctl help 2>&1")
    refute_match(/.*No such file or directory.*/, output)
    refute_match(/.*command not found.*/, output)
    assert_match(/.*mmctl \[command\].*/, output)
  end
end
