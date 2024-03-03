class StructurizrCli < Formula
  desc "Command-line utility for Structurizr"
  homepage "https://structurizr.com"
  url "https://mirror.ghproxy.com/https://github.com/structurizr/cli/releases/download/v2024.03.02/structurizr-cli.zip"
  sha256 "28129a7b827e5f898c18592a2f25cf3e60e3485cc9bf141781b4b98f51d79f19"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "67a30afa6bee6c482bd8d5ad438823ce352c7827cb58d5ab9fe8d2a6bb694fa6"
  end

  depends_on "openjdk"

  def install
    rm_f Dir["*.bat"]
    libexec.install Dir["*"]
    (bin/"structurizr-cli").write_env_script libexec/"structurizr.sh", Language::Java.overridable_java_home_env
  end

  test do
    result = shell_output("#{bin}/structurizr-cli validate -w /dev/null", 1)
    assert_match "/dev/null is not a JSON or DSL file", result

    assert_match "structurizr-cli: #{version}", shell_output("#{bin}/structurizr-cli version")
  end
end
