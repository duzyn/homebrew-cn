class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v20.10.22",
      revision: "3a2c30b63ab20acfcc3f3550ea756a0561655a77"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "37ee4ed9e2354f89f4e3247e5bea687281d3c71a9773c9a169e7d19996ef1a02"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6762bc55f1086e7ab75598e88a583ca5d569f4bf9b5f7c91aa56e95bbf80ef1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6756150ec302a7bf5f93cf1a7a1186b48053fff656f2ad2ba9210c13097940e8"
    sha256 cellar: :any_skip_relocation, ventura:        "c2b5b13fc92178684960837326bddd6b9b513e52d35923e7dad5739c43d33dc5"
    sha256 cellar: :any_skip_relocation, monterey:       "350ae01379a0a0bb70d9468fce7d8dcc07ef44ef54bb8715c79e13a595642acf"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ebd7558b7119de7826628d08ba487a2d40ea1926f047a1e0c0cebc7a68f40a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3920453f6f7a0bf8bdded82158e7e9940f5fed10adc21c8955465df2536e83b8"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build

  conflicts_with "docker-completion", because: "docker already includes these completion scripts"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    dir = buildpath/"src/github.com/docker/cli"
    dir.install (buildpath/"").children
    cd dir do
      ldflags = ["-X \"github.com/docker/cli/cli/version.BuildTime=#{time.iso8601}\"",
                 "-X github.com/docker/cli/cli/version.GitCommit=#{Utils.git_short_head}",
                 "-X github.com/docker/cli/cli/version.Version=#{version}",
                 "-X \"github.com/docker/cli/cli/version.PlatformName=Docker Engine - Community\""]
      system "go", "build", *std_go_args(ldflags: ldflags), "github.com/docker/cli/cmd/docker"

      Pathname.glob("man/*.[1-8].md") do |md|
        section = md.to_s[/\.(\d+)\.md\Z/, 1]
        (man/"man#{section}").mkpath
        system "go-md2man", "-in=#{md}", "-out=#{man/"man#{section}"/md.stem}"
      end

      bash_completion.install "contrib/completion/bash/docker"
      fish_completion.install "contrib/completion/fish/docker.fish"
      zsh_completion.install "contrib/completion/zsh/_docker"
    end
  end

  test do
    assert_match "Docker version #{version}", shell_output("#{bin}/docker --version")

    expected = if OS.mac?
      "ERROR: Cannot connect to the Docker daemon"
    else
      "ERROR: Got permission denied while trying to connect to the Docker daemon socket"
    end
    assert_match expected, shell_output("#{bin}/docker info", 1)
  end
end
