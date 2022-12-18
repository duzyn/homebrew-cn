class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://github.com/mineiros-io/terramate"
  url "https://github.com/mineiros-io/terramate/archive/refs/tags/v0.2.6.tar.gz"
  sha256 "ebb871e60724c3f834f84e082aacce55072a1d241348410b5f7100c6bce3b8e0"
  license "Apache-2.0"
  head "https://github.com/mineiros-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc4ad199f3225456eb19d5002f016242dc8dba5e6011b304df936d00b6d64714"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b3e14bfb71a5e16494a8cf1815741672f7b1401726f8ca6fd2849bbeac2c84e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "769f87ce9d6db69b8a6ccdcdcb566da7511b52682a050e050fb5a8c99954670f"
    sha256 cellar: :any_skip_relocation, ventura:        "c0b04d63355ca7553d4d3117cbb9590e2e2d6cf04154fd57baa620dccecf70d6"
    sha256 cellar: :any_skip_relocation, monterey:       "19364132c99244de9d033ba9a35d1dd8c468c796fde87a4f2a718e4ee683469b"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b7f9f5d4e18bdf5f0b311240d389ebb4236f63996d0a578b64cd05fafc20129"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d4d1be98c7ef777d85d8376e376bd3fe18d2199a08fa3640593cf2d7f03f959"
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
