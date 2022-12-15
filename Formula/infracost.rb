class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.10.15.tar.gz"
  sha256 "566be4b7fc228d07a842c11797a5976d4699226ece752b0ff5f9867c2e0e4301"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a197a0e99c0e1dcf6e872fc3c6eed1cb668cf058c4318b74ce504e75df1dd146"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7bd619624885b70a1450539e0b1677975e86c2cad954c24813b061bbb3d434c6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "368b94e88cb53ae52cf9736b6027b629d58613088682870694e5f4e4eadaeac5"
    sha256 cellar: :any_skip_relocation, ventura:        "e58d350f66a22cefc08d806a9573d6fe6737492091761f5683222083800e6b87"
    sha256 cellar: :any_skip_relocation, monterey:       "07bd1fe053a76b47b761814beab38266cc9205367f6d6bd0c5ebbf755287f299"
    sha256 cellar: :any_skip_relocation, big_sur:        "07bd1fe053a76b47b761814beab38266cc9205367f6d6bd0c5ebbf755287f299"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "764a411a82a8e9b24a2b6bd3f06959b154ffc95d72d542eb9a71cde35d114a48"
  end

  depends_on "go" => :build
  depends_on "terraform" => :test

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X github.com/infracost/infracost/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/infracost"

    generate_completions_from_executable(bin/"infracost", "completion", "--shell")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/infracost --version 2>&1")

    output = shell_output("#{bin}/infracost breakdown --no-color 2>&1", 1)
    assert_match "No INFRACOST_API_KEY environment variable is set.", output
  end
end
