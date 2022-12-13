class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.192.tar.gz"
  sha256 "f37d8931db551dfe78b368869f5785466a791894910e515e30d1f9fb94af95cd"
  license "Apache-2.0"
  head "https://github.com/werf/werf.git", branch: "main"

  # This repository has some tagged versions that are higher than the newest
  # stable release (e.g., `v1.5.2`) and the `GithubLatest` strategy is
  # currently necessary to identify the correct latest version.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd7a02ea10d1005b5f5b741195766f19d8e48969c902d155d987c1c9cfc141fd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98b3c0db0cd96e58f4bf02f88f7b547bcf8f9a83ef90982d2a3c88ec48af85ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f2f57233393cf0a5779d6ddf0ebee1d6cab8007fa0e352350473f112765822b1"
    sha256 cellar: :any_skip_relocation, ventura:        "283445c30642041119eca6da960730c59f13e370f81cae5899699a15515fa86a"
    sha256 cellar: :any_skip_relocation, monterey:       "0cd08f1a602de2fbdfa267a062d4bca4c82c2ce27e99ea9f50090ddd1f0a83e0"
    sha256 cellar: :any_skip_relocation, big_sur:        "3c2128c153a3a6091ce04a53d4bb0154744c812938cf14cfbf3d3a015efa32e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f61ba2f7dc1a90ed44ba66d01db1ecb7d60d2c3d59382faa9a378ca9ef9ce84"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "btrfs-progs"
    depends_on "device-mapper"
  end

  def install
    if OS.linux?
      ldflags = %W[
        -linkmode external
        -extldflags=-static
        -s -w
        -X github.com/werf/werf/pkg/werf.Version=#{version}
      ]
      tags = %w[
        dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp
        osusergo exclude_graphdriver_devicemapper netgo no_devmapper static_build
      ].join(" ")
    else
      ldflags = "-s -w -X github.com/werf/werf/pkg/werf.Version=#{version}"
      tags = "dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp"
    end

    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags, "./cmd/werf"

    generate_completions_from_executable(bin/"werf", "completion")
  end

  test do
    werf_config = testpath/"werf.yaml"
    werf_config.write <<~EOS
      configVersion: 1
      project: quickstart-application
      ---
      image: vote
      dockerfile: Dockerfile
      context: vote
      ---
      image: result
      dockerfile: Dockerfile
      context: result
      ---
      image: worker
      dockerfile: Dockerfile
      context: worker
    EOS

    output = <<~EOS
      - image: vote
      - image: result
      - image: worker
    EOS

    system "git", "init"
    system "git", "add", werf_config
    system "git", "commit", "-m", "Initial commit"

    assert_equal output, shell_output("#{bin}/werf config graph")

    assert_match version.to_s, shell_output("#{bin}/werf version")
  end
end
