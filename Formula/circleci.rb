class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.22770",
      revision: "802994bb588db994da3d625fe46acfb8c2268d37"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "478d9ac1c7a35205113bd5b320cf3824088c20eae26daf7c1414378e0731a908"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62a769fa2a82d5c3e27d176e52f9914ef5d8e8b42cc7d61564c067212d8b1e72"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "18ff0ec5f8c075c560a95c514cc03322743d5abfdfa4b86181834fad2d029fdf"
    sha256 cellar: :any_skip_relocation, ventura:        "b3d513afd728b9eee9c1787503c353f1783af19855de5079ac5b7ce0d90bca7e"
    sha256 cellar: :any_skip_relocation, monterey:       "1aa75cdef212afb810a0b6d62554c6bee72b2c3c24739785947afcf93bc97121"
    sha256 cellar: :any_skip_relocation, big_sur:        "33b55cdfa0013bcb2140cb47886a919e172c42069bf61edd62b3f0fa7e9fe7a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c78ae4ff9bc500b62cf749c06f77872231fe13f5804e6b9ab526a46f959068c"
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
