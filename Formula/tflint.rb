class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/v0.44.1.tar.gz"
  sha256 "079e5f25cf18c33f9b3ac69942b5f8b5de917c41dcfd6039ca9faad739a7613e"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b0cab2478fc3d86f52e39c7ca572b89eb9f83dbf27a5d468c437158b1fc8780"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dda00780c069cd586a5e952f67b6de6864d8162054336dbcb46d67210e083fbe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e69cac4e4a609b1acf60ff1bd3e022fa517a4627f65568cda39bd05dd245b3ba"
    sha256 cellar: :any_skip_relocation, ventura:        "a2a7fa30998326c123311379bab3870134ea5b126c50eed3d9d4608128a5141b"
    sha256 cellar: :any_skip_relocation, monterey:       "199f80835635c05bbed2bde3a2a04dd377655172af7e569cd57c3814018763eb"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d6d209f8acbd4baf3c23c07528bdc236607eb91d0bd422e3bba3671eb429143"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ecbbfd03bd533369ecee25c70163160e8f2326458fdfad681ad5f338bad32a1a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-o", bin/"tflint"
  end

  test do
    (testpath/"test.tf").write <<~EOS
      terraform {
        required_providers {
          aws = {
            source = "hashicorp/aws"
            version = "~> 4"
          }
        }
      }

      provider "aws" {
        region = var.aws_region
      }
    EOS

    # tflint returns exitstatus: 0 (no issues), 2 (errors occured), 3 (no errors but issues found)
    assert_match "", shell_output("#{bin}/tflint test.tf")
    assert_equal 0, $CHILD_STATUS.exitstatus
    assert_match version.to_s, shell_output("#{bin}/tflint --version")
  end
end
