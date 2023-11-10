class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://ghproxy.com/https://github.com/onflow/cadence/archive/refs/tags/v0.42.4.tar.gz"
  sha256 "1d3b525a111b6bc349a1e69dbb9d194bfe554ef99da8fed4e08381fd7068105b"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4a86822d273dcf12509185a13595184f8655ce62a3c8c84f9938ebef2eef75a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2402271ef772b5f08c2c6915c55f725be8d2eb3d87536466b67cbb841bb135ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5e80b8b6d37437e2811723234c53df81e29b22aecbdf43cef6d2e1e31f4593d"
    sha256 cellar: :any_skip_relocation, sonoma:         "d6e326333a7c5181ce842c72571ab9d425df24858138d63e8a66d26b315750e6"
    sha256 cellar: :any_skip_relocation, ventura:        "b5433da263f28b881ae2854fcaf60e44be1e3804a3826ca89fc88c371f30794e"
    sha256 cellar: :any_skip_relocation, monterey:       "8d832ade117d3e35f53bd4e2f5bc339c4524ee448e3c4ed926ddd5c458a38a02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "465359ff7affbd85ffd73161228fc3c3844c4c3a5ad59923c193a20c82e59973"
  end

  depends_on "go" => :build

  conflicts_with "cadence-workflow", because: "both install a `cadence` executable"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./runtime/cmd/main"
  end

  test do
    (testpath/"hello.cdc").write <<~EOS
      pub fun main(): Int {
        return 0
      }
    EOS
    system "#{bin}/cadence", "hello.cdc"
  end
end
