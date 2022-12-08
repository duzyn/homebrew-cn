class Hcl2json < Formula
  desc "Convert HCL2 to JSON"
  homepage "https://github.com/tmccombs/hcl2json"
  url "https://github.com/tmccombs/hcl2json/archive/refs/tags/v0.3.6.tar.gz"
  sha256 "500a7a6b85c2ca2da357c8b95fd39caa298e9e9bd46167651c62c380d9ebfc7e"
  license "Apache-2.0"
  head "https://github.com/tmccombs/hcl2json.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11f8d47d705d970f6f311b60ae52e49c15cd4ea5dfc0522b754af7db86c02132"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11f8d47d705d970f6f311b60ae52e49c15cd4ea5dfc0522b754af7db86c02132"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "11f8d47d705d970f6f311b60ae52e49c15cd4ea5dfc0522b754af7db86c02132"
    sha256 cellar: :any_skip_relocation, ventura:        "63d8ce597be648f1c4c798c35af743a981cdb141d0e612f790157f28d65f0582"
    sha256 cellar: :any_skip_relocation, monterey:       "63d8ce597be648f1c4c798c35af743a981cdb141d0e612f790157f28d65f0582"
    sha256 cellar: :any_skip_relocation, big_sur:        "63d8ce597be648f1c4c798c35af743a981cdb141d0e612f790157f28d65f0582"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "647256c3d6e217b7362377461de59e4c1bdbca7ce79cd0afd358c96b493f4115"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    test_hcl = <<~HCL
      resource "my_resource_type" "test_resource" {
        input = "magic_test_value"
      }
    HCL

    test_json = {
      resource: {
        my_resource_type: {
          test_resource: [
            {
              input: "magic_test_value",
            },
          ],
        },
      },
    }.to_json

    assert_equal test_json, pipe_output("#{bin}/hcl2json", test_hcl).gsub(/\s+/, "")
    assert_match "Failed to convert", pipe_output("#{bin}/hcl2json 2>&1", "Hello, Homebrew!", 1)
  end
end
