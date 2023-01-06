class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.42.6.tar.gz"
  sha256 "b59aaba96dc832229605eba107415550264b51611ba0d188d1e33340c6c1194f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6113135c89518ea1c0bb815e509cf15eaa787cb4a7e85f8097aa67da0d21e41e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "130d4eeb503fd5c262efcb3298cadc13eb00f3d798533616fc3ded4633deb365"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e36f2658b317cae77f9ffdb9dd08f56456b5efed85522e832ae4a2e1b0929a9"
    sha256 cellar: :any_skip_relocation, ventura:        "67258ca180e31bf904e41ef8c041fd8d3b982650205ef4a59d259e9a8782f4d4"
    sha256 cellar: :any_skip_relocation, monterey:       "1ace054203365e863ea7352f537759f74779ec538d7fa7306efaa7dafe770882"
    sha256 cellar: :any_skip_relocation, big_sur:        "b6b791e5923abfcf9bb9300696ebf42e40b91af3622d9212f2da0c3ebab9a69c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d34207890c8fe38f225daca8ef45e447beba386bffa4688974abf9523eac7d58"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
