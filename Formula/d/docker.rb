class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v28.0.2",
      revision: "0442a7378f37ef9482ade1c8addf618cb8becb00"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84c6869be2b3f5023734b148c0a7365005935f634ade9f66f55e899bd44ea5bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84c6869be2b3f5023734b148c0a7365005935f634ade9f66f55e899bd44ea5bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "84c6869be2b3f5023734b148c0a7365005935f634ade9f66f55e899bd44ea5bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "aae29dc6349692cc4ada0dabd8d551b29679eea4e9e78e427d438f9f918c909f"
    sha256 cellar: :any_skip_relocation, ventura:       "aae29dc6349692cc4ada0dabd8d551b29679eea4e9e78e427d438f9f918c909f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "297ceee7ef10f39eff38dab187ba82f3e360f878c7473fd783e334a9b5383f4f"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build
  depends_on "docker-completion"

  def install
    # TODO: Drop GOPATH when merged/released: https://github.com/docker/cli/pull/4116
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    (buildpath/"src/github.com/docker").install_symlink buildpath => "cli"

    ldflags = %W[
      -s -w
      -X github.com/docker/cli/cli/version.BuildTime=#{time.iso8601}
      -X github.com/docker/cli/cli/version.GitCommit=#{Utils.git_short_head}
      -X github.com/docker/cli/cli/version.Version=#{version}
      -X "github.com/docker/cli/cli/version.PlatformName=Docker Engine - Community"
    ]

    system "go", "build", *std_go_args(ldflags:), "github.com/docker/cli/cmd/docker"

    Pathname.glob("man/*.[1-8].md") do |md|
      section = md.to_s[/\.(\d+)\.md\Z/, 1]
      (man/"man#{section}").mkpath
      system "go-md2man", "-in=#{md}", "-out=#{man}/man#{section}/#{md.stem}"
    end
  end

  test do
    assert_match "Docker version #{version}", shell_output("#{bin}/docker --version")

    expected = "Client: Docker Engine - Community\n Version:    #{version}\n Context:    default\n Debug Mode: false\n\nServer:"
    assert_match expected, shell_output("#{bin}/docker info", 1)
  end
end
