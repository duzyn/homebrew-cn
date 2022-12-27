class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft.git",
      tag:      "v0.64.0",
      revision: "e1e489a2849c8432781a7cb58b257fa935efa1cf"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b758c5f98f6f4d194d0cb7d08023e22dc93331049084ff2f4ae108efbbd06a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e36117f08f482c17455d325602911bf21c27812b7b33fea61783f14d7ef069bb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9beb11398836a7be4e0e2002a3e39449f3c3dc2ae654d89b75daa4660b8071dd"
    sha256 cellar: :any_skip_relocation, ventura:        "00a37cdb48f434cacb63c7613090a9b783ccae5f84ddfd3915bb5109b19de516"
    sha256 cellar: :any_skip_relocation, monterey:       "de05f031bcc85f06e434e08b0b62cfab38b07264376b3dac4a16180c9e59473a"
    sha256 cellar: :any_skip_relocation, big_sur:        "13230e1949691156d35c6251acd28c732e554d0578900cb06ec42238dd170dc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a179a4deb922dc552027b0472ab8d5a1d67ec90a49b824922db0ffdd8b9a61af"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.com/anchore/syft/internal/version.version=#{version}
      -X github.com/anchore/syft/internal/version.gitCommit=#{Utils.git_head}
      -X github.com/anchore/syft/internal/version.buildDate=#{time.iso8601}
    ]

    # Building for OSX with -extldflags "-static" results in the error:
    # ld: library not found for -lcrt0.o
    # This is because static builds are only possible if all libraries
    ldflags << "-linkmode \"external\" -extldflags \"-static\"" if OS.linux?

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/syft"
  end

  test do
    output = shell_output("#{bin}/syft attest busybox 2>&1", 1)
    assert_match "Available formats: [syft-json spdx-json cyclonedx-json]", output

    assert_match version.to_s, shell_output("#{bin}/syft --version")
  end
end
