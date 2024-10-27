class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://mirror.ghproxy.com/https://github.com/chainguard-dev/apko/archive/refs/tags/v0.19.4.tar.gz"
  sha256 "74c0bff58c81a364d27fc36b0c401523da775b0942685662f84b4bf18a72c210"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87ea97cd953173af174be19a2412e98e7a76311b8bdb603f3d8fe57ed27dd78f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87ea97cd953173af174be19a2412e98e7a76311b8bdb603f3d8fe57ed27dd78f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "87ea97cd953173af174be19a2412e98e7a76311b8bdb603f3d8fe57ed27dd78f"
    sha256 cellar: :any_skip_relocation, sonoma:        "16910ef119d00e9ff17ced6b6f4a4c7d77820edf9d16cd275332fbfe810b387f"
    sha256 cellar: :any_skip_relocation, ventura:       "16910ef119d00e9ff17ced6b6f4a4c7d77820edf9d16cd275332fbfe810b387f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f062e323dd62173eeb6bea0ae28b9db563f1bfc577f5d36856a3b686ba537a87"
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
    (testpath/"test.yml").write <<~EOS
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
    EOS
    system bin/"apko", "build", testpath/"test.yml", "apko-alpine:test", "apko-alpine.tar"
    assert_predicate testpath/"apko-alpine.tar", :exist?

    assert_match version.to_s, shell_output(bin/"apko version 2>&1")
  end
end
