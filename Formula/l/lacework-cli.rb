class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.41.0",
      revision: "e5dc8b211c50d38af014cd192e3755ef4c4405d2"
  license "Apache-2.0"
  head "https://github.com/lacework/go-sdk.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b32639b9af5c06e276a935280afd8f24115677b296919d02130de9fc8698a21f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2312540c8bc980c607d45a6e807dc7e87fa154c7c2371d994a2086b6c4ebeb65"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40db386b3f5cba075fc81becd0cf8d82f255d30ca546226cae96b3aad086ed68"
    sha256 cellar: :any_skip_relocation, sonoma:         "2de2b191c90fdf454e791318915ef6b3e8515e38c864a40e5ae6cbc98367010d"
    sha256 cellar: :any_skip_relocation, ventura:        "58527ce76ffe253f1495afe2ef19d2d686ec4cc429128ffe35934d6c6be4e2b8"
    sha256 cellar: :any_skip_relocation, monterey:       "31770cf52aaeac21efdcb11d1e5aec5a0a4482ebf8a49427bdadf1cc61f31408"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ce992236cb9a739c1707dbf17ae9a8375ea1a1fddb73c57b08cbcb5af5ffa6a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/lacework/go-sdk/cli/cmd.Version=#{version}
      -X github.com/lacework/go-sdk/cli/cmd.GitSHA=#{Utils.git_head}
      -X github.com/lacework/go-sdk/cli/cmd.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(output: bin/"lacework", ldflags: ldflags), "./cli"

    generate_completions_from_executable(bin/"lacework", "completion", base_name: "lacework")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lacework version")

    output = shell_output("#{bin}/lacework configure list 2>&1", 1)
    assert_match "ERROR unable to load profiles. No configuration file found.", output
  end
end
