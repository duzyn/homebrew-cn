class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v27.2.0",
      revision: "3ab42569583b58dbc6f167d842d5a3dd5972065f"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8a7a2e963a9d3192a6666f52c0cd15b1eee481ade00c7e41ec129eae4b9b6424"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a7a2e963a9d3192a6666f52c0cd15b1eee481ade00c7e41ec129eae4b9b6424"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a7a2e963a9d3192a6666f52c0cd15b1eee481ade00c7e41ec129eae4b9b6424"
    sha256 cellar: :any_skip_relocation, sonoma:         "d5725b5f465e9e7c2d11ba90f6cc226a854d54d0a5a1e6826b9aaacb1ae7a407"
    sha256 cellar: :any_skip_relocation, ventura:        "d5725b5f465e9e7c2d11ba90f6cc226a854d54d0a5a1e6826b9aaacb1ae7a407"
    sha256 cellar: :any_skip_relocation, monterey:       "d5725b5f465e9e7c2d11ba90f6cc226a854d54d0a5a1e6826b9aaacb1ae7a407"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbfcb9d52d3e2d115417a61bd9f8c0ee62ae264fdb0eeda97d27512c46bf8553"
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
