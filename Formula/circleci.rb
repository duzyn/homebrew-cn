class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.22426",
      revision: "7cd9cc4df4679b2527daff299ae38f623e11750e"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da32c0bf17ab27d2520abbb4be4eaa4ec61440b927745ab67da15296ad15952e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3471acc92c16b62ef59ca647b2eb56b93be9c8c91cb8825206d1e0a47ce162c2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "373617f8f81dd1a8d2d7ea0cefdb594280a8b01684bba9681aa7c03d68a4fae0"
    sha256 cellar: :any_skip_relocation, ventura:        "f89d4cd7500cea3abecf1631646191a6e1b9e9e2511e0a28a6fce95b749c901e"
    sha256 cellar: :any_skip_relocation, monterey:       "adbe006c7207c37e5ff09113c2825967f5150c0efbfd0476a66d51d1748522c4"
    sha256 cellar: :any_skip_relocation, big_sur:        "9cb6f4078b02c6d9ea87c699d317732e102511f7ed8abc3ceb76ce57da18e116"
    sha256 cellar: :any_skip_relocation, catalina:       "69688fe88a7acd94323c9f22e970b41012a78f4573e1c372dea1f6312f06df8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44e03629e7c9153fe541016753e0e0f5eb8449ed3503f61e0a6b13b2794ec0f5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/CircleCI-Public/circleci-cli/version.packageManager=homebrew
      -X github.com/CircleCI-Public/circleci-cli/version.Version=#{version}
      -X github.com/CircleCI-Public/circleci-cli/version.Commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"circleci", "--skip-update-check", "completion",
                                        shells: [:bash, :zsh])
  end

  test do
    # assert basic script execution
    assert_match(/#{version}\+.{7}/, shell_output("#{bin}/circleci version").strip)
    (testpath/".circleci.yml").write("{version: 2.1}")
    output = shell_output("#{bin}/circleci config pack #{testpath}/.circleci.yml")
    assert_match "version: 2.1", output
    # assert update is not included in output of help meaning it was not included in the build
    assert_match(/update.+This command is unavailable on your platform/, shell_output("#{bin}/circleci help 2>&1"))
    assert_match "`update` is not available because this tool was installed using `homebrew`.",
      shell_output("#{bin}/circleci update")
  end
end
