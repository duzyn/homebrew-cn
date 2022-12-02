class AwsIamAuthenticator < Formula
  desc "Use AWS IAM credentials to authenticate to Kubernetes"
  homepage "https://github.com/kubernetes-sigs/aws-iam-authenticator"
  url "https://github.com/kubernetes-sigs/aws-iam-authenticator.git",
      tag:      "v0.5.12",
      revision: "4762dbd89dd45df5083b40ca1c1806d589e8acae"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/aws-iam-authenticator.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc0142003299d7ee358778cef5acbbd4cea98aeead23905b1589369e64992670"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "462fe85e9c206ef75e5517cbb0f5e671f57a907197778a13cc5ab0f1d4a6210e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4dae1c923ad4997c047ada5d2b651eec2206340552d699dbd9a88f35c94b5a08"
    sha256 cellar: :any_skip_relocation, ventura:        "43c23444c326f0fc3fc9ead271a5c51560713945a2f1cc7d42816012c2786d99"
    sha256 cellar: :any_skip_relocation, monterey:       "e9b9150d356779e1e81cdf0337e3bc224187b6226898eb6dffbf02722b68eb6f"
    sha256 cellar: :any_skip_relocation, big_sur:        "9071bc77e68313dab8ae5331df4a0038833469ad58a0cfbfcebef01ac290f1e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3dc9148fd3c844467db49bca90776c0c7b14e19eb4cfe6166a7c4016da075bb"
  end

  depends_on "go" => :build

  def install
    ldflags = ["-s", "-w",
               "-X sigs.k8s.io/aws-iam-authenticator/pkg.Version=#{version}",
               "-X sigs.k8s.io/aws-iam-authenticator/pkg.CommitID=#{Utils.git_head}",
               "-buildid=''"]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/aws-iam-authenticator"
    prefix.install_metafiles
  end

  test do
    output = shell_output("#{bin}/aws-iam-authenticator version")
    assert_match %Q("Version":"#{version}"), output

    system "#{bin}/aws-iam-authenticator", "init", "-i", "test"
    contents = Dir.entries(".")
    ["cert.pem", "key.pem", "aws-iam-authenticator.kubeconfig"].each do |created|
      assert_includes contents, created
    end
  end
end
