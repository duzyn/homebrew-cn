class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v25.0.0",
      revision: "e758fe5a7fb956b126ca5f9eb2df5a86c4841fbd"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f1bf2d7b36d884d3245bc3389667b0b336e7f3195203a15c5704ce14a4769aec"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "944d84998165dfd58cd2aeb5444327d78a2a7ef09a8e5afd3a8b1a5ada9ec2ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "773c8d80fae4b03fcaa2cf258e5b981f2b826ebca64bbcdbe47c93977fe8b463"
    sha256 cellar: :any_skip_relocation, sonoma:         "00829beaddc9b7e1bd58d022d057eef8c0e79ba9260d4af38ccce583322a1918"
    sha256 cellar: :any_skip_relocation, ventura:        "57b3b09e9c2b10e39e94529ebb9e30229eb6a1183f6acfc57aba944213048c49"
    sha256 cellar: :any_skip_relocation, monterey:       "278752f080b05a2489a1de2b69a0b033f390b3e873f14208d56198ce0b3ad653"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9b53953c24c0f10e1e3d3df405ebd3f4ad5f0d3a092a9aebba4711949e34bb9"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build
  depends_on "docker-completion"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"

    (buildpath/"src/github.com/docker").install_symlink buildpath => "cli"
    ldflags = ["-X \"github.com/docker/cli/cli/version.BuildTime=#{time.iso8601}\"",
               "-X github.com/docker/cli/cli/version.GitCommit=#{Utils.git_short_head}",
               "-X github.com/docker/cli/cli/version.Version=#{version}",
               "-X \"github.com/docker/cli/cli/version.PlatformName=Docker Engine - Community\""]

    system "go", "build", *std_go_args(ldflags: ldflags), "github.com/docker/cli/cmd/docker"

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
