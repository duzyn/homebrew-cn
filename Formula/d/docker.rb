class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v26.1.0",
      revision: "9714adc6c797755f63053726c56bc1c17c0c9204"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "477d7a0ce1820393454ddf43b5d23aff3d002f056945b4db181cf6de29b95bfd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "29623354566234e13f228b7ccc83dfdf68bc5d552f240535198cd1484b2510eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3dab8b2b29dde675504141ef1e7258404a15e9c7e2e3f5c3811b7bfcf8289400"
    sha256 cellar: :any_skip_relocation, sonoma:         "5e0389a097ad7bcac3b059eef9c51f00d1a72ba939cb9b2e32b61bd669d76f03"
    sha256 cellar: :any_skip_relocation, ventura:        "f0952f282e63b762d2531192a790d4740aa2c9d8760a2e96e95427dc46f4d613"
    sha256 cellar: :any_skip_relocation, monterey:       "ecf2fc53e00dc5d481f81825db93228b7d529a2e7e4e32cf7cfdafcb93775bbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fb34ef6a049d1526d84ad6711a3b4d9e34dc761d98ead6910ea0299010266ab"
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
