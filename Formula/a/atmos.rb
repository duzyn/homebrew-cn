class Atmos < Formula
  desc "Universal Tool for DevOps and Cloud Automation"
  homepage "https://github.com/cloudposse/atmos"
  url "https://mirror.ghproxy.com/https://github.com/cloudposse/atmos/archive/refs/tags/v1.123.0.tar.gz"
  sha256 "e783d8b4ae64546a1f64b1c0f09eb1800d03a29f46db8bfacaca0227955133ad"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "271a1f4fe90432cfcc8499d24db4f23ee1e4a0112cf4ba4cfbbdc74a6d83e7f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "271a1f4fe90432cfcc8499d24db4f23ee1e4a0112cf4ba4cfbbdc74a6d83e7f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "271a1f4fe90432cfcc8499d24db4f23ee1e4a0112cf4ba4cfbbdc74a6d83e7f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fff58624ff8af9089fb7d1f60a49cd20a88e4ce18f2b228fed84d37db183f8a"
    sha256 cellar: :any_skip_relocation, ventura:       "7fff58624ff8af9089fb7d1f60a49cd20a88e4ce18f2b228fed84d37db183f8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "703651bb923222ac4d049a66a64033720a5bd6a64dec2bc93678f8db84b28016"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "tenv symlinks atmos binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X 'github.com/cloudposse/atmos/pkg/version.Version=#{version}'")

    generate_completions_from_executable(bin/"atmos", "completion")
  end

  test do
    # create basic atmos.yaml
    (testpath/"atmos.yaml").write <<~YAML
      components:
        terraform:
          base_path: "./components/terraform"
          apply_auto_approve: false
          deploy_run_init: true
          auto_generate_backend_file: false
        helmfile:
          base_path: "./components/helmfile"
          kubeconfig_path: "/dev/shm"
          helm_aws_profile_pattern: "{namespace}-{tenant}-gbl-{stage}-helm"
          cluster_name_pattern: "{namespace}-{tenant}-{environment}-{stage}-eks-cluster"
      stacks:
        base_path: "./stacks"
        included_paths:
          - "**/*"
        excluded_paths:
          - "globals/**/*"
          - "catalog/**/*"
          - "**/*globals*"
        name_pattern: "{tenant}-{environment}-{stage}"
      logs:
        verbose: false
        colors: true
    YAML

    # create scaffold
    mkdir_p testpath/"stacks"
    mkdir_p testpath/"components/terraform/top-level-component1"
    (testpath/"stacks/tenant1-ue2-dev.yaml").write <<~YAML
      terraform:
        backend_type: s3 # s3, remote, vault, static, etc.
        backend:
          s3:
            encrypt: true
            bucket: "eg-ue2-root-tfstate"
            key: "terraform.tfstate"
            dynamodb_table: "eg-ue2-root-tfstate-lock"
            acl: "bucket-owner-full-control"
            region: "us-east-2"
            role_arn: null
          remote:
          vault:

      vars:
        tenant: tenant1
        region: us-east-2
        environment: ue2
        stage: dev

      components:
        terraform:
          top-level-component1: {}
    YAML

    # create expected file
    (testpath/"backend.tf.json").write <<~JSON
      {
        "terraform": {
          "backend": {
            "s3": {
              "workspace_key_prefix": "top-level-component1",
              "acl": "bucket-owner-full-control",
              "bucket": "eg-ue2-root-tfstate",
              "dynamodb_table": "eg-ue2-root-tfstate-lock",
              "encrypt": true,
              "key": "terraform.tfstate",
              "region": "us-east-2",
              "role_arn": null
            }
          }
        }
      }
    JSON

    system bin/"atmos", "terraform", "generate", "backend", "top-level-component1", "--stack", "tenant1-ue2-dev"
    actual_json = JSON.parse(File.read(testpath/"components/terraform/top-level-component1/backend.tf.json"))
    expected_json = JSON.parse(File.read(testpath/"backend.tf.json"))
    assert_equal expected_json["terraform"].to_set, actual_json["terraform"].to_set

    assert_match "Atmos #{version}", shell_output("#{bin}/atmos version")
  end
end
