class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v1.3.7.tar.gz"
  sha256 "36bc7319bf97965144a38c2670f458752f7cb8e7fd783c216b4a24bebee2a8c4"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/terraform/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c13c765453b199ccf32e327a7e70c84056fa23fe2da942e8ef649c9539f2a0e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38a323dd41bb355bfd3b05eef3bec9137d4492f874060b928f2ce48bc1f99cec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3dd7b757e332116c79edabb070c6f51fa9a2dc642021124f2040964b90ef17de"
    sha256 cellar: :any_skip_relocation, ventura:        "7f9bcc5e9a3a927f78ea4960394d1e72916e7eb3fd8af0c9c6d47e0f401986b0"
    sha256 cellar: :any_skip_relocation, monterey:       "46a9eb69dad8d93f1343fb2d83ff1a091f330c018da72b0583359b9377f93d04"
    sha256 cellar: :any_skip_relocation, big_sur:        "027c6946d196c54569bbf75f692e922f0b92df8baf1e34e000537b3602164d77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77b89c32e2da1c90b7d5f7e783815bb18dffaec98d51ba2f37bcd571f77515a5"
  end

  depends_on "go" => :build

  conflicts_with "tfenv", because: "tfenv symlinks terraform binaries"

  # Needs libraries at runtime:
  # /usr/lib/x86_64-linux-gnu/libstdc++.so.6: version `GLIBCXX_3.4.29' not found (required by node)
  fails_with gcc: "5"

  def install
    # v0.6.12 - source contains tests which fail if these environment variables are set locally.
    ENV.delete "AWS_ACCESS_KEY"
    ENV.delete "AWS_SECRET_KEY"

    # resolves issues fetching providers while on a VPN that uses /etc/resolv.conf
    # https://github.com/hashicorp/terraform/issues/26532#issuecomment-720570774
    ENV["CGO_ENABLED"] = "1"

    system "go", "build", *std_go_args, "-ldflags", "-s -w"
  end

  test do
    minimal = testpath/"minimal.tf"
    minimal.write <<~EOS
      variable "aws_region" {
        default = "us-west-2"
      }

      variable "aws_amis" {
        default = {
          eu-west-1 = "ami-b1cf19c6"
          us-east-1 = "ami-de7ab6b6"
          us-west-1 = "ami-3f75767a"
          us-west-2 = "ami-21f78e11"
        }
      }

      # Specify the provider and access details
      provider "aws" {
        access_key = "this_is_a_fake_access"
        secret_key = "this_is_a_fake_secret"
        region     = var.aws_region
      }

      resource "aws_instance" "web" {
        instance_type = "m1.small"
        ami           = var.aws_amis[var.aws_region]
        count         = 4
      }
    EOS
    system "#{bin}/terraform", "init"
    system "#{bin}/terraform", "graph"
  end
end
