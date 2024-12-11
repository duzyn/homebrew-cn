class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v27.4.0",
      revision: "bde2b893136c1c7a2894386e4f8743089c89b041"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de0bb1445d1d89281d0ca2bfe06fc5adea7f6869bffbd4e6fa06be1fa4b93c6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de0bb1445d1d89281d0ca2bfe06fc5adea7f6869bffbd4e6fa06be1fa4b93c6d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "de0bb1445d1d89281d0ca2bfe06fc5adea7f6869bffbd4e6fa06be1fa4b93c6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e8c77827d689bde6eebc4dce208221de2b252a387d21bcc97e9d3ad3787fd21"
    sha256 cellar: :any_skip_relocation, ventura:       "9e8c77827d689bde6eebc4dce208221de2b252a387d21bcc97e9d3ad3787fd21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74ba74a8e7e9aebd3675e1cbaa08516e0c280bea2253681e056eaaf50fa97f55"
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
