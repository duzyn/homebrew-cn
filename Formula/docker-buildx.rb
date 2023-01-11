class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https://docs.docker.com/buildx/working-with-buildx/"
  url "https://github.com/docker/buildx.git",
      tag:      "v0.10.0",
      revision: "876462897612d36679153c3414f7689626251501"
  license "Apache-2.0"
  head "https://github.com/docker/buildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02deecd9edb7659507bfd3fa08720e6ef81405f96f1ff85ca2cee81811d48424"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "339184effb309212e6496503e1479a5be0faf79f665a273013c46911f5f63655"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4f1a2499cc1bec9fd0b82bfb8f36a3a9d9fdee101c3d86590427eafea8cf8d82"
    sha256 cellar: :any_skip_relocation, ventura:        "fa7de03b9fc37fb73274168dc760732afa886e9e59f49917a81fd7ac39318b37"
    sha256 cellar: :any_skip_relocation, monterey:       "69d2000eac06bb9f7565b624ec405ae9d958526b7ad86ad4680ca40fd74d39ca"
    sha256 cellar: :any_skip_relocation, big_sur:        "994034faba10298d360baa35c813d30741d4a90f11fc5433c907d4f70d317ba4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86ddfc86e0e949191268a7730070b8dbf61bfaf5c7a40a258913cd6758cd8346"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/docker/buildx/version.Version=v#{version}
      -X github.com/docker/buildx/version.Revision=#{Utils.git_head}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/buildx"

    doc.install Dir["docs/reference/*.md"]

    generate_completions_from_executable(bin/"docker-buildx", "completion")
  end

  def caveats
    <<~EOS
      docker-buildx is a Docker plugin. For Docker to find this plugin, symlink it:
        mkdir -p ~/.docker/cli-plugins
        ln -sfn #{opt_bin}/docker-buildx ~/.docker/cli-plugins/docker-buildx
    EOS
  end

  test do
    assert_match "github.com/docker/buildx v#{version}", shell_output("#{bin}/docker-buildx version")
    output = shell_output(bin/"docker-buildx build . 2>&1", 1)
    assert_match(/(denied while trying to|Cannot) connect to the Docker daemon/, output)
  end
end
