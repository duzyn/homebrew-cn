class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.144.0",
      revision: "1dd366951f615e09490803d6afa45b41f58c983c"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b80c0f8f0465d5b50eb23e178dbc7bb81d276f08f257ec7b226a2678160ad421"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34ace7bc0bb732c403c06521df901a37bf52063de6a76f1403b31fc3b31d98cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b0c107df233e109bca6af05e618c660a4338b856fcbe2e75c970d202e7d2ec8e"
    sha256 cellar: :any_skip_relocation, sonoma:        "90f82bc28cd3e85ce41a26d22f1fe2268ac4c1fa7797dd1b3dcd190639924a27"
    sha256 cellar: :any_skip_relocation, ventura:       "43efcd7d022c7b3f67dcb20be1db704fdcb33de3492ff7e647cdd5506c95d4f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7de2a1b86d58062049049e1075a1b0a34418689f4a52a1dd07f4079409b5d090"
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
    assert_predicate testpath/"Pulumi.yaml", :exist?, "Project was not created"
  end
end
