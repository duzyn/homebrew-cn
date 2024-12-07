class Terramaid < Formula
  desc "Utility for generating Mermaid diagrams from Terraform configurations"
  homepage "https://github.com/RoseSecurity/Terramaid"
  url "https://mirror.ghproxy.com/https://github.com/RoseSecurity/Terramaid/archive/refs/tags/v2.0.3.tar.gz"
  sha256 "9285972d08be966b697f496d0957ba9436766de1c5291026cce481753a877d02"
  license "Apache-2.0"
  head "https://github.com/RoseSecurity/Terramaid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f49bc604e7847cc9b9f63eea6f92f42e1cadd3302ebe9aa3a03e631ac116bc7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f49bc604e7847cc9b9f63eea6f92f42e1cadd3302ebe9aa3a03e631ac116bc7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6f49bc604e7847cc9b9f63eea6f92f42e1cadd3302ebe9aa3a03e631ac116bc7"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a5ac43e61611a2797737c8c8d317ab8fe7d09ad651afdabe96e60457b717fa5"
    sha256 cellar: :any_skip_relocation, ventura:       "7a5ac43e61611a2797737c8c8d317ab8fe7d09ad651afdabe96e60457b717fa5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cf367c712f6b779154a8946950fe16868379ab50423dc480e12dd7742885244"
  end

  depends_on "go" => [:build, :test]

  def install
    ldflags = "-s -w -X github.com/RoseSecurity/terramaid/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"terramaid", "completion")
  end

  test do
    resource "terraform" do
      # https://www.hashicorp.com/blog/hashicorp-adopts-business-source-license
      # Do not update terraform, it switched to the BUSL license
      # Waiting for https://github.com/runatlantis/atlantis/issues/3741
      url "https://mirror.ghproxy.com/https://github.com/hashicorp/terraform/archive/refs/tags/v1.5.7.tar.gz"
      sha256 "6742fc87cba5e064455393cda12f0e0241c85a7cb2a3558d13289380bb5f26f5"
    end

    resource("terraform").stage do
      system "go", "build", *std_go_args(ldflags: "-s -w", output: testpath/"terraform")
    end

    ENV.prepend_path "PATH", testpath

    (testpath/"main.tf").write <<~HCL
      resource "aws_instance" "example" {
        ami           = "ami-0c55b159cbfafe1f0"
        instance_type = "t2.micro"
      }
    HCL

    system bin/"terramaid", "run", "-w", testpath.to_s, "-o", testpath/"output.mmd"
    assert_predicate testpath/"output.mmd", :exist?

    assert_match version.to_s, shell_output("#{bin}/terramaid version")
  end
end
