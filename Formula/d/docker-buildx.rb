class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https://docs.docker.com/buildx/working-with-buildx/"
  url "https://mirror.ghproxy.com/https://github.com/docker/buildx/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "f846f36dc93d78e9b1c94b716279a04f1d6f58ef5d445c6615ec8e5e3a7b5efa"
  license "Apache-2.0"
  head "https://github.com/docker/buildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "64248f719465a0a3d991bf93ac603f5ce141855b61862e2b60343137305525e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "64248f719465a0a3d991bf93ac603f5ce141855b61862e2b60343137305525e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "64248f719465a0a3d991bf93ac603f5ce141855b61862e2b60343137305525e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64248f719465a0a3d991bf93ac603f5ce141855b61862e2b60343137305525e2"
    sha256 cellar: :any_skip_relocation, sonoma:         "cdedeb57dda1963363f15e965baa14471d7a2d3947a2258988b3e9fdc1e81391"
    sha256 cellar: :any_skip_relocation, ventura:        "cdedeb57dda1963363f15e965baa14471d7a2d3947a2258988b3e9fdc1e81391"
    sha256 cellar: :any_skip_relocation, monterey:       "cdedeb57dda1963363f15e965baa14471d7a2d3947a2258988b3e9fdc1e81391"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "777a95efbdc0dc9e54060fcbe88d7127de5447bd04d325b3049dfa7bacd06578"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/docker/buildx/version.Version=v#{version}
      -X github.com/docker/buildx/version.Revision=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/buildx"

    (lib/"docker/cli-plugins").install_symlink bin/"docker-buildx"

    doc.install Dir["docs/reference/*.md"]

    generate_completions_from_executable(bin/"docker-buildx", "completion")
  end

  def caveats
    <<~EOS
      docker-buildx is a Docker plugin. For Docker to find the plugin, add "cliPluginsExtraDirs" to ~/.docker/config.json:
        "cliPluginsExtraDirs": [
            "#{HOMEBREW_PREFIX}/lib/docker/cli-plugins"
        ]
    EOS
  end

  test do
    assert_match "github.com/docker/buildx v#{version}", shell_output("#{bin}/docker-buildx version")
    output = shell_output(bin/"docker-buildx build . 2>&1", 1)
    assert_match(/(denied while trying to|Cannot) connect to the Docker daemon/, output)
  end
end
