class Atmos < Formula
  desc "Universal Tool for DevOps and Cloud Automation"
  homepage "https://github.com/cloudposse/atmos"
  url "https://mirror.ghproxy.com/https://github.com/cloudposse/atmos/archive/refs/tags/v1.86.1.tar.gz"
  sha256 "1e0c5f0b7ce3ac70fd5e3abd0aabc204ef4bdf734f4f8263f99f11c39c7c6195"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2996f4c86dff1b8af64ae4acd1351bf95244756d4b800809e6e826d313cbfa10"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2996f4c86dff1b8af64ae4acd1351bf95244756d4b800809e6e826d313cbfa10"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2996f4c86dff1b8af64ae4acd1351bf95244756d4b800809e6e826d313cbfa10"
    sha256 cellar: :any_skip_relocation, sonoma:         "47a1a9ebefeddbcf817142b1007349bfee26827780405db7827eaee6e02e21f7"
    sha256 cellar: :any_skip_relocation, ventura:        "47a1a9ebefeddbcf817142b1007349bfee26827780405db7827eaee6e02e21f7"
    sha256 cellar: :any_skip_relocation, monterey:       "47a1a9ebefeddbcf817142b1007349bfee26827780405db7827eaee6e02e21f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f29c72e9bcefeb7e82b42920eb328ae929cc361e13754ad9b3038fc9ab9dec69"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "tenv symlinks atmos binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X 'github.com/cloudposse/atmos/cmd.Version=#{version}'")

    generate_completions_from_executable(bin/"atmos", "completion")
  end

  test do
    # create basic atmos.yaml
    (testpath/"atmos.yaml").write <<~EOT
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
    EOT

    # create scaffold
    mkdir_p testpath/"stacks"
    mkdir_p testpath/"components/terraform/top-level-component1"
    (testpath/"stacks/tenant1-ue2-dev.yaml").write <<~EOT
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
    EOT

    # create expected file
    (testpath/"backend.tf.json").write <<~EOT
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
    EOT

    system bin/"atmos", "terraform", "generate", "backend", "top-level-component1", "--stack", "tenant1-ue2-dev"
    actual_json = JSON.parse(File.read(testpath/"components/terraform/top-level-component1/backend.tf.json"))
    expected_json = JSON.parse(File.read(testpath/"backend.tf.json"))
    assert_equal expected_json["terraform"].to_set, actual_json["terraform"].to_set
  end
end
