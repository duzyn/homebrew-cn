class Buildkit < Formula
  desc "Сoncurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit.git",
      tag:      "v0.11.0",
      revision: "830288a71f447b46ad44ad5f7bd45148ec450d44"
  license "Apache-2.0"
  head "https://github.com/moby/buildkit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "524b8766bd973e41a33be7a7beae53b28a0b3257f7c8e379d7e8ab4d4edc1d5a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "904e34bf88ceca1412efbc720c0e29183310b10ae22955f0badef09f97142e9f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ba570d210a3dd79555bfc97c901b4a460f13bd4f2f8370f8d25740af8d3c2d4"
    sha256 cellar: :any_skip_relocation, ventura:        "ab57e0332ba605dda7721a3bb34f529d739f5531ea3108b0734398636211e883"
    sha256 cellar: :any_skip_relocation, monterey:       "b194aa34f710fa53f80a1102ffff482bfa7b7c51b7aa805b0fbe4b9cb7a98a9b"
    sha256 cellar: :any_skip_relocation, big_sur:        "144e005a2ef432c585c24f88d7ede8e936d5ad73e8db6a4f317889b96d4ecebf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a20db532281846e0d50a433802a462c49315edc60a38f161453f7275fb6a2bc3"
  end

  depends_on "go" => :build

  def install
    revision = Utils.git_head
    ldflags = %W[
      -s -w
      -X github.com/moby/buildkit/version.Version=#{version}
      -X github.com/moby/buildkit/version.Revision=#{revision}
      -X github.com/moby/buildkit/version.Package=github.com/moby/buildkit
    ]

    system "go", "build", "-mod=vendor", *std_go_args(ldflags: ldflags, output: bin/"buildctl"), "./cmd/buildctl"

    doc.install Dir["docs/*.md"]
  end

  test do
    assert_match "make sure buildkitd is running",
      shell_output("#{bin}/buildctl --addr unix://dev/null --timeout 0 du 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/buildctl --version")
  end
end
