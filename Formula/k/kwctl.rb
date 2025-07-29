class Kwctl < Formula
  desc "CLI tool for the Kubewarden policy engine for Kubernetes"
  homepage "https://www.kubewarden.io/"
  url "https://mirror.ghproxy.com/https://github.com/kubewarden/kwctl/archive/refs/tags/v1.27.0.tar.gz"
  sha256 "474a85ec4e3eb470952effbf0ffbc67df6532176329bc535d7c95cb6114f6702"
  license "Apache-2.0"
  head "https://github.com/kubewarden/kwctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b864c0be19fb99d99a7124f5aec9ab74d9e01402350c472c470c6d87676e3d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46b96f09c1a59af412a30ea145b7ad300e0981d7f13e7f6a22fad578d429d09c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "653a1d9839b66c32f6fca3802e94de033cc56a477837d1063e2d1c4230767bfc"
    sha256 cellar: :any_skip_relocation, sonoma:        "470271e7af9172742aa8edc1a3948d4b7d00e7fd4832782a66bbae1559335f12"
    sha256 cellar: :any_skip_relocation, ventura:       "ec3fa5452956cf23db0fdc16662e9945a86fdd8c31b1ec147b3aca4934f78218"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11848e0a943b3f329f09cc975bb4448ab8588a8294199341068f69a9e7ec7740"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "213dcc9961c298b3fc29b8b1bcfd111e01d1ea8851bfbd006e97774c51dc944b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"kwctl", "completions", "--shell")
  end

  test do
    test_policy = "ghcr.io/kubewarden/policies/safe-labels:v0.1.7"
    assert_equal "kwctl #{version}", shell_output("#{bin}/kwctl --version").strip.split("\n")[0]
    system bin/"kwctl", "pull", test_policy
    assert_match test_policy, shell_output("#{bin}/kwctl policies")

    (testpath/"ingress.json").write <<~JSON
      {
        "uid": "1299d386-525b-4032-98ae-1949f69f9cfc",
        "kind": {
          "group": "networking.k8s.io",
          "kind": "Ingress",
          "version": "v1"
        },
        "resource": {
          "group": "networking.k8s.io",
          "version": "v1",
          "resource": "ingresses"
        },
        "name": "foobar",
        "operation": "CREATE",
        "userInfo": {
          "username": "kubernetes-admin",
          "groups": [
            "system:masters",
            "system:authenticated"
          ]
        },
        "object": {
          "apiVersion": "networking.k8s.io/v1",
          "kind": "Ingress",
          "metadata": {
            "name": "tls-example-ingress",
            "labels": {
              "owner": "team"
            }
          },
          "spec": {
          }
        }
      }
    JSON
    (testpath/"policy-settings.json").write <<~JSON
      {
        "denied_labels": [
          "owner"
        ]
      }
    JSON

    output = shell_output(
      "#{bin}/kwctl run " \
      "registry://#{test_policy} " \
      "--request-path #{testpath}/ingress.json " \
      "--settings-path #{testpath}/policy-settings.json",
    )
    assert_match "The following labels are denied: owner", output
  end
end
