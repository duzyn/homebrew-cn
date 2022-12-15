class GitXargs < Formula
  desc "CLI for making updates across multiple Github repositories with a single command"
  homepage "https://github.com/gruntwork-io/git-xargs"
  url "https://github.com/gruntwork-io/git-xargs/archive/v0.1.3.tar.gz"
  sha256 "f9347d4634b43f8fe10d76cce7a62faefacff945fcd6759929657ec03d105fb9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c63f00da0e78c9c31b52c0ebaa68187d2001029acae87dc38cca60a0e38834b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28bfffc04a13d6749e680557007482bcf1d402da18961024831fef1ff7680c6f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf67eda7ec926ef5365b82684c384a62a6130c93e8e965181eeb128b2193439e"
    sha256 cellar: :any_skip_relocation, ventura:        "edb5f7e8472c29ab90bb606e68a91cf2c63ab676fb677cc43486a089210cdf66"
    sha256 cellar: :any_skip_relocation, monterey:       "91f99afbeeeeceb77ec41080c24056c1ffcd78c8a19b874864a1c6c6af4a3d9e"
    sha256 cellar: :any_skip_relocation, big_sur:        "628461a8b30a425856d1d5741faf5354afbf0b619ee2815f64c017fd6e295695"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01ee6428e1f7002b89bda7c11261cb4753ca41e9279ee449b9dd0d7c69ebfa4a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-xargs --version")

    assert_match "You must export a valid Github personal access token as GITHUB_OAUTH_TOKEN",
                  shell_output("#{bin}/git-xargs --branch-name test-branch" \
                               "--github-org brew-test-org" \
                               "--commit-message 'Create hello-world.txt'" \
                               "touch hello-world.txt 2>&1", 1)
  end
end
