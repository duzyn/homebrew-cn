class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/v0.44.0.tar.gz"
  sha256 "21629f4cfe3348020dea7b850ae5e003091f8f19fd621a1bd7a5e4fe4517ec79"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f29d60a3fa3125c7e870f85da7dc9075e7cd06e74ecee3e47f70852870651369"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c009c0b4bcd7a549f4e80923d50b1a635875486daad784ae1ae39892584814f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "40ac4b8d88978d185d7b751a3d4600c36b5d90394564a5e6a43dc1dcb86c120d"
    sha256 cellar: :any_skip_relocation, ventura:        "cd79d321bd949a747d328e45d97a9d58799cc89daad967f8e89489346afd2a41"
    sha256 cellar: :any_skip_relocation, monterey:       "586e6a6c980f34665e93860e4607ed98ef35282538a8c26f16fe81808a2550e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "f069261cb36151b1e595253967445845bd1a419bf69abea8cd13a120af54fbce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53c94f76fb79715911c62c2cc81b3e786128fd09e87ebc16dd8fe196b3cb1273"
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
