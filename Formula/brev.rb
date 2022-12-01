class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.184.tar.gz"
  sha256 "16129cde8e51d8038ab8e0a08b2abca4190f20a848f7108a2434a2c2491e8999"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4188d29893b1a52b975ddfd5a5f87fffa6a1b0c7aaa656bc552edd46c351d81"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a602bc6cf1d9986bbc0dcfce7edc2fa4e1091e04a1e4f397b7ae34fc282a39e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "79ece6b7c329632f74c1a465b045a52a2325b88889b4425872e867834033c046"
    sha256 cellar: :any_skip_relocation, ventura:        "ee10978d12237c9a45236a2cdb10a0af67728c4de318efee52a8dee0834df099"
    sha256 cellar: :any_skip_relocation, monterey:       "4619644d281b63ff340bc2700688a5bd468059d7d5a7e09cf252fe8a0e6bb937"
    sha256 cellar: :any_skip_relocation, big_sur:        "75c84ae683307480a0e65f911d3181ad3a1ea357c063c9ebbcb6daf3e3d4a63c"
    sha256 cellar: :any_skip_relocation, catalina:       "e6cb44ca743491f6c31a476f1705430375e330c4714d6fca932e9036a977fa82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "858ba6bb3726245998a7f177b234c3c50d7adae23e78b64eedb094a9a3b94cba"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"brev", "completion")
  end

  test do
    system bin/"brev", "healthcheck"
  end
end
