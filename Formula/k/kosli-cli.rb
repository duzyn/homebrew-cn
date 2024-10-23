class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://mirror.ghproxy.com/https://github.com/kosli-dev/cli/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "808601e571735cab606612116a6783e65b89214662754e9a281c5c9cd0be1e41"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95c8b25de1f2e383cf9e63a7fedf22b9872ee040344e6a11385a1ec2dea8d991"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95c8b25de1f2e383cf9e63a7fedf22b9872ee040344e6a11385a1ec2dea8d991"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "95c8b25de1f2e383cf9e63a7fedf22b9872ee040344e6a11385a1ec2dea8d991"
    sha256 cellar: :any_skip_relocation, sonoma:        "c01271439bd4a5ef9a8d2c4dca87e614125c732a4f9a9895eaf7b68c44cb7399"
    sha256 cellar: :any_skip_relocation, ventura:       "c01271439bd4a5ef9a8d2c4dca87e614125c732a4f9a9895eaf7b68c44cb7399"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b917954d0d43e69ac6e49fbec75408d622b1c42c039f11c75dceb54b3d38d699"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags:), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", "completion", base_name: "kosli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end
