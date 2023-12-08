class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.96.1",
      revision: "60b250eeb06ffb530e51851b27b6e5c16dcbf91d"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aacde9a3917ae4d1a88703e54bd4ee934ff00e8ae6166c2401f0e95e338297af"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "03ca76febf0f02abbd230086b540c036f7e5c64c1eb47c1be501616d2f2bc175"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c391b3a9239fd637005ea411de15a8189a20042b6314f39b4ce167a84fd54310"
    sha256 cellar: :any_skip_relocation, sonoma:         "dc39e47fc578532443153e082dc751aa9e9cf71201a90767d8acb69f7c82b898"
    sha256 cellar: :any_skip_relocation, ventura:        "fb15ec7f8cae5ec34c82328800c565a3b16cc52cbf9d42452dd1fc1f2dbdff7b"
    sha256 cellar: :any_skip_relocation, monterey:       "a330abef7f18be18c93828823388449041d80feb3084238313730964970332be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a797b417b7b5b682e149d0126a11f4746bba8fea08686bb26c50e071461c49e4"
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
    system "#{bin}/pulumi", "new", "aws-typescript", "--generate-only",
                                                     "--force", "-y"
    assert_predicate testpath/"Pulumi.yaml", :exist?, "Project was not created"
  end
end
