class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v28.1.0",
      revision: "4d8c241ff09be37e7cfd120424a8a2f9fe3dff0d"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97dce417e84fb4ccdbee98bc7bd55ba2adcbec8c8fd88a52a588068f4bcccbe1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97dce417e84fb4ccdbee98bc7bd55ba2adcbec8c8fd88a52a588068f4bcccbe1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "97dce417e84fb4ccdbee98bc7bd55ba2adcbec8c8fd88a52a588068f4bcccbe1"
    sha256 cellar: :any_skip_relocation, sonoma:        "5efa55e02afb9a5d4adbb5e4cae99f0c244dfee1e138a7706f9b402fb43141f8"
    sha256 cellar: :any_skip_relocation, ventura:       "5efa55e02afb9a5d4adbb5e4cae99f0c244dfee1e138a7706f9b402fb43141f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02d53c8dcbd124ebc262333d787935b08fdbe48e5a038c2adee63badcb004929"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build
  depends_on "docker-completion"

  conflicts_with cask: "docker"

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
