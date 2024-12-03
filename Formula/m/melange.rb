class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://mirror.ghproxy.com/https://github.com/chainguard-dev/melange/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "7fa2b555f87f5ff39d37aeac54c9d57923a460fceb787fd02f6566af5e590e1f"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fbc2982bf3d39f754a5b0c64760c7ba10a653e016e73cbf0c08317cf34e13623"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbc2982bf3d39f754a5b0c64760c7ba10a653e016e73cbf0c08317cf34e13623"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fbc2982bf3d39f754a5b0c64760c7ba10a653e016e73cbf0c08317cf34e13623"
    sha256 cellar: :any_skip_relocation, sonoma:        "ffba75f8fce322ee632c5b5658c0c392018ec23c8f158227b9b3b8e1fec3023d"
    sha256 cellar: :any_skip_relocation, ventura:       "ffba75f8fce322ee632c5b5658c0c392018ec23c8f158227b9b3b8e1fec3023d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b3aff39d20e98963f0e3816c6cfbaf81a631f939294d8ea5f37c97dbf9d9196"
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

    generate_completions_from_executable(bin/"melange", "completion")
  end

  test do
    (testpath/"test.yml").write <<~YAML
      package:
        name: hello
        version: 2.12
        epoch: 0
        description: "the GNU hello world program"
        copyright:
          - paths:
            - "*"
            attestation: |
              Copyright 1992, 1995, 1996, 1997, 1998, 1999, 2000, 2001, 2002, 2005,
              2006, 2007, 2008, 2010, 2011, 2013, 2014, 2022 Free Software Foundation,
              Inc.
            license: GPL-3.0-or-later
        dependencies:
          runtime:

      environment:
        contents:
          repositories:
            - https://dl-cdn.alpinelinux.org/alpine/edge/main
          packages:
            - alpine-baselayout-data
            - busybox
            - build-base
            - scanelf
            - ssl_client
            - ca-certificates-bundle

      pipeline:
        - uses: fetch
          with:
            uri: https://ftp.gnu.org/gnu/hello/hello-${{package.version}}.tar.gz
            expected-sha256: cf04af86dc085268c5f4470fbae49b18afbc221b78096aab842d934a76bad0ab
        - uses: autoconf/configure
        - uses: autoconf/make
        - uses: autoconf/make-install
        - uses: strip
    YAML

    assert_equal "hello-2.12-r0", shell_output("#{bin}/melange package-version #{testpath}/test.yml")

    system bin/"melange", "keygen"
    assert_predicate testpath/"melange.rsa", :exist?

    assert_match version.to_s, shell_output(bin/"melange version 2>&1")
  end
end
