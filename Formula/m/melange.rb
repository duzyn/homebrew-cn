class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://mirror.ghproxy.com/https://github.com/chainguard-dev/melange/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "fba5cb907c0292de2dab0773486837230156d39f5860e984a955c2c341861202"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6347ad5c127ff7a9248da03d3b8df3c53567b039d1461e1a7ed51e3b5897bae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6347ad5c127ff7a9248da03d3b8df3c53567b039d1461e1a7ed51e3b5897bae"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e6347ad5c127ff7a9248da03d3b8df3c53567b039d1461e1a7ed51e3b5897bae"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1e44608a5be508d76e54225404f6bd2dcf31f7b5950e3afe97cc7ad0b8a9d32"
    sha256 cellar: :any_skip_relocation, ventura:       "a1e44608a5be508d76e54225404f6bd2dcf31f7b5950e3afe97cc7ad0b8a9d32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fc1a2bd0afce0e1ad908ec3842db713e3711cc2394b62816aae409ac7083c8a"
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
    (testpath/"test.yml").write <<~EOS
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
    EOS

    assert_equal "hello-2.12-r0", shell_output("#{bin}/melange package-version #{testpath}/test.yml")

    system bin/"melange", "keygen"
    assert_predicate testpath/"melange.rsa", :exist?

    assert_match version.to_s, shell_output(bin/"melange version 2>&1")
  end
end
