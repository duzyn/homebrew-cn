class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://github.com/aquasecurity/trivy/archive/v0.36.0.tar.gz"
  sha256 "52a9bf424934d68f04ff75a50e1daa792a3b733d80528c301c96f6249f46b47c"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d7854f989c9163ef9a85ae3189dc87c8ff3eae9c647b6d2109a485ed2df65d51"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f65034cc03534cf366321d6eb461e3fd7c0f08c38e31eafbc7e3919b3eb105b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f8cabf4642cceb494187eee63467f7e65bbff1c343c4d642752d44b1399f7840"
    sha256 cellar: :any_skip_relocation, ventura:        "49f3dcbd9a46a4cf1449739058969f9dd57889413c239fce85a4c814f3e636f6"
    sha256 cellar: :any_skip_relocation, monterey:       "712af81e4152cb382313c09bfaf9e7e8fcdd7d6e149032dffb64188303b30e4f"
    sha256 cellar: :any_skip_relocation, big_sur:        "74e9164f0c92f81839f9252f9e9fc7bae53158acf4a62e7cc4e34dc70d631343"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76ff1634e1792eb14de1ae7d6bcd067c7f07d138a3cbd794451f558469dcbd44"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X=main.version=#{version}"), "./cmd/trivy"
  end

  test do
    output = shell_output("#{bin}/trivy image alpine:3.10")
    assert_match(/\(UNKNOWN: \d+, LOW: \d+, MEDIUM: \d+, HIGH: \d+, CRITICAL: \d+\)/, output)

    assert_match version.to_s, shell_output("#{bin}/trivy --version")
  end
end
