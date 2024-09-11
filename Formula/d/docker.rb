class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v27.2.1",
      revision: "9e34c9bb39efd8bf96d4ec044de454ef1f24c668"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "9baf183fa180604ef422c4508ef16ef409a753b5fa04df13a30da9dd24a1d51b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9baf183fa180604ef422c4508ef16ef409a753b5fa04df13a30da9dd24a1d51b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9baf183fa180604ef422c4508ef16ef409a753b5fa04df13a30da9dd24a1d51b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9baf183fa180604ef422c4508ef16ef409a753b5fa04df13a30da9dd24a1d51b"
    sha256 cellar: :any_skip_relocation, sonoma:         "ca654cea409dc2f7a2344b92d1acc009b6a0c8b86459fef8b5cd5fe3f3d541c4"
    sha256 cellar: :any_skip_relocation, ventura:        "ca654cea409dc2f7a2344b92d1acc009b6a0c8b86459fef8b5cd5fe3f3d541c4"
    sha256 cellar: :any_skip_relocation, monterey:       "ca654cea409dc2f7a2344b92d1acc009b6a0c8b86459fef8b5cd5fe3f3d541c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c98d06c8f8fa02adc6c0603fdc9ec890f3ad0b37a974ef666bd08c0f9f3597f8"
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
