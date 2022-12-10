class Linkerd < Formula
  desc "Command-line utility to interact with linkerd"
  homepage "https://linkerd.io"
  url "https://github.com/linkerd/linkerd2.git",
      tag:      "stable-2.12.3",
      revision: "5dc8f520aa5ff92c805a8d69778b003f067ea850"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^stable[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d395481cd2f54a56ba680eb50a13bf35ed3cf8d1847887cf6774bea7f85a4990"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e83342e0067752da5aa67d0fe603ecc7f667d09a97bad00c3bfb6d18b286d01"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3269f3c3f58900c5ce3ebc3ce806ecd8d2b047b74103379c01bae1588c4d45f3"
    sha256 cellar: :any_skip_relocation, ventura:        "20d0afeb5d862843bc3bcd5757cab50d31733b99cd805db85f8d64dedf7c7427"
    sha256 cellar: :any_skip_relocation, monterey:       "4f3cab2052a13b7f265cfe44e6e85cd1046f75108d9409cf4477235c39b0ab6a"
    sha256 cellar: :any_skip_relocation, big_sur:        "d7e1b41e66f144ecd7db0a6534dc348b228cce861a7aacea2658e7d3754d1c11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "244218ec73871ff88f0f16b678b46429fa62ad2d6f35c73f81269e1875ffdcf3"
  end

  depends_on "go" => :build

  def install
    ENV["CI_FORCE_CLEAN"] = "1"

    system "bin/build-cli-bin"
    bin.install Dir["target/cli/*/linkerd"]
    prefix.install_metafiles

    generate_completions_from_executable(bin/"linkerd", "completion")
  end

  test do
    run_output = shell_output("#{bin}/linkerd 2>&1")
    assert_match "linkerd manages the Linkerd service mesh.", run_output

    version_output = shell_output("#{bin}/linkerd version --client 2>&1")
    assert_match "Client version: ", version_output
    assert_match stable.specs[:tag], version_output if build.stable?

    system bin/"linkerd", "install", "--ignore-cluster"
  end
end
