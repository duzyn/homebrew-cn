class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.151.0",
      revision: "c0cd4ce67a298af7956116e035a37d4cc4d5511b"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a538230729fc1e6fd211abf608d9890e2677f3698d24dcbdf21e3766dc170cce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "197e4aef3cd0bc577748fcb47251ba09ae5ce8bfc79612603320aec3847697ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bd97385c975e93cd4f627057acf018c20b555aa9f84d518f18b20e3793da9eac"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f5f5e39e1a6e450ae0f72ae027a08cecbcad74c16afce35f1208e0a9767dd80"
    sha256 cellar: :any_skip_relocation, ventura:       "5f455ff37997fe440cd2dea3f3cba8bbc3f56639d883c50af994b390719ebbab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e37fb703451440935bc88e983557b01c7c150173fe0accb8784bac2f748a3959"
  end

  depends_on "go" => :build

  def install
    cd "./sdk" do
      system "go", "mod", "download"
    end
    cd "./pkg" do
      system "go", "mod", "download"
    end

    system "make", "brew"

    bin.install Dir["#{ENV["GOPATH"]}/bin/pulumi*"]

    # Install shell completions
    generate_completions_from_executable(bin/"pulumi", "gen-completion")
  end

  test do
    ENV["PULUMI_ACCESS_TOKEN"] = "local://"
    ENV["PULUMI_TEMPLATE_PATH"] = testpath/"templates"
    system bin/"pulumi", "new", "aws-typescript", "--generate-only",
                                                     "--force", "-y"
    assert_path_exists testpath/"Pulumi.yaml", "Project was not created"
  end
end
