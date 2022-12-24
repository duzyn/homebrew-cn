class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://github.com/mineiros-io/terramate"
  url "https://github.com/mineiros-io/terramate/archive/refs/tags/v0.2.7.tar.gz"
  sha256 "e47bc8971917dd612762235c41683f01d58514036a1451be100cb1a9d1b13085"
  license "Apache-2.0"
  head "https://github.com/mineiros-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e186dbbea38a77d79b0eab200dddc489ca5cf68134146a8557ba53efe83cbd89"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d9e0ce6b6b69b35ee05fe50c4102cfea9b5b76c4c6b5061b3f654233c905c52"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6db6b7156b90c4d7aadf19888660151f6cfc6faeb34d51a75cf40c02b615e8f9"
    sha256 cellar: :any_skip_relocation, ventura:        "ce73689aae1423ff54c0b497e33e02f48fe62d6483bf9d6da3816491e7c0ee94"
    sha256 cellar: :any_skip_relocation, monterey:       "3c591b096855200c424f771e2f34750a75c8b0a37b03f53cffa466511991e746"
    sha256 cellar: :any_skip_relocation, big_sur:        "7b7e11414271ccdcb799218a384ee8dce26984865e5d1d7e41f40f12c8c0d570"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a26c502ac7981508e0fa129e56ca1418b13d3528ea61b44d48dd0146c9e2f5e0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/terramate"
  end

  test do
    assert_match "project root not found", shell_output("#{bin}/terramate list 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/terramate version")
  end
end
