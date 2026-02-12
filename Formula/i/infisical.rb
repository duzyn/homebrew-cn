class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://mirror.ghproxy.com/https://github.com/Infisical/cli/archive/refs/tags/v0.43.52.tar.gz"
  sha256 "7392076fb44a8e2bec180bbd79aa74a197aef084d6368e20531e5738fa6a5c3f"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00dc172dde93deb6645a0f9c16e4aea6f43bfaec616024b46330a31f7361f97e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00dc172dde93deb6645a0f9c16e4aea6f43bfaec616024b46330a31f7361f97e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00dc172dde93deb6645a0f9c16e4aea6f43bfaec616024b46330a31f7361f97e"
    sha256 cellar: :any_skip_relocation, sonoma:        "bbc9dd0b65600aa63b66776f6a893a54fb1de07e232c27022dbdd13660f784dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed0a095bd324f5a44c423e3fb01b29c5374e4aca0b36dd19ab38ad780592e3bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13829b3982d61fac36e531fb05b87483bf508b1b87a59b4537e6c517090806b5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"infisical", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/infisical --version")

    output = shell_output("#{bin}/infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}/infisical agent 2>&1")
    assert_match "starting Infisical agent", output
  end
end
