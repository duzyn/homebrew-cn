class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://mirror.ghproxy.com/https://github.com/chainguard-dev/apko/archive/refs/tags/v0.29.10.tar.gz"
  sha256 "376b04238940cfdc4fdc0428af34a72f6aa992a2695920c9b90435e2a8635fa1"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/apko.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "307bfaff86e0694e4d46e331ce40919ae2c1f803b49758abddf4fcc8b4d7abf3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd36711242084bea402fc4aea69666230044faedccb5d8ca8448d4541c085b26"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "63f7c6ef04f8bb43c80b85624481a3974d76306d3fde74a6ce3a88ff5f2051c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ea22ed3191feb97a571b11ecb6d9383c364dfe8aaebcda15ccd7b73ca832b45"
    sha256 cellar: :any_skip_relocation, ventura:       "488793721e207ab56002b2ab18480dd71d7546446fbbdf744efd9231792b9e98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f96d281a499c26907ab85add1cc90a9d571a879ec788fe0969ab1d027b03ebfb"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.io/release-utils/version.gitVersion=#{version}
      -X sigs.k8s.io/release-utils/version.gitCommit=brew
      -X sigs.k8s.io/release-utils/version.gitTreeState=clean
      -X sigs.k8s.io/release-utils/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"apko", "completion")
  end

  test do
    (testpath/"test.yml").write <<~YAML
      contents:
        repositories:
          - https://dl-cdn.alpinelinux.org/alpine/edge/main
        packages:
          - alpine-base

      entrypoint:
        command: /bin/sh -l

      # optional environment configuration
      environment:
        PATH: /usr/sbin:/sbin:/usr/bin:/bin

      # only key found for arch riscv64 [edge],
      archs:
        - riscv64
    YAML
    system bin/"apko", "build", testpath/"test.yml", "apko-alpine:test", "apko-alpine.tar"
    assert_path_exists testpath/"apko-alpine.tar"

    assert_match version.to_s, shell_output(bin/"apko version 2>&1")
  end
end
