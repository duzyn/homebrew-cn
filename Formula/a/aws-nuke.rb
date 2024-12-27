class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://github.com/ekristen/aws-nuke"
  url "https://mirror.ghproxy.com/https://github.com/ekristen/aws-nuke/archive/refs/tags/v3.38.1.tar.gz"
  sha256 "2b082135742abaf48a79807bb1fb52c3cca271ff3af4c180331e632f446221e9"
  license "MIT"
  head "https://github.com/ekristen/aws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52bb54ac59de93237b77c3632a1baabcdf920c4d280018d7f227d62de708c126"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52bb54ac59de93237b77c3632a1baabcdf920c4d280018d7f227d62de708c126"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "52bb54ac59de93237b77c3632a1baabcdf920c4d280018d7f227d62de708c126"
    sha256 cellar: :any_skip_relocation, sonoma:        "caffb75b0866d6b2b817528fe56e04eeb72cbd576ad15937d21e7d3ce86e80cb"
    sha256 cellar: :any_skip_relocation, ventura:       "caffb75b0866d6b2b817528fe56e04eeb72cbd576ad15937d21e7d3ce86e80cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c07131ecb5efda60c7949afa50fbd0762a2bf2fef4745b4b397246ed50e6c39f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/ekristen/aws-nuke/v#{version.major}/pkg/common.SUMMARY=#{version}
    ]
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags:)

    pkgshare.install "pkg/config"

    generate_completions_from_executable(bin/"aws-nuke", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aws-nuke --version")
    assert_match "InvalidClientTokenId", shell_output(
      "#{bin}/aws-nuke run --config #{pkgshare}/config/testdata/example.yaml \
      --access-key-id fake --secret-access-key fake 2>&1",
      1,
    )
    assert_match "IAMUser", shell_output("#{bin}/aws-nuke resource-types")
  end
end
