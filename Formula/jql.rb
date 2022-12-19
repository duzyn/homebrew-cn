class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/v5.1.4.tar.gz"
  sha256 "a640b41cb04a7bedf098b86859c8295277cec0e6f295bd5688a1cf94de5c4774"
  license "MIT"
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ad41b3036cfd1a3deea5f162a0500f75186cdea66996c782252d57dfaf70c9e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aeb405ab6dedbdb15eff9f771ea78a9796a09da323045b1e9ced0710ec5b96a5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe3b941a451bb1dd35688de75d0b56d113a4fcb2784cf9274bf1ac9a8ca2b6f8"
    sha256 cellar: :any_skip_relocation, ventura:        "e5b7cdf75771b8bf814045c0ffcb7db668eb4838590f27e1419d0d71f1f8b528"
    sha256 cellar: :any_skip_relocation, monterey:       "3098d1e2b4f630f82c196ddbe09233ea4f88638e0f2cf4c3aa4a627495950727"
    sha256 cellar: :any_skip_relocation, big_sur:        "977dc177eb3faf701036ce62cea3b875c9f9b00eb75cb001260b20976a5145c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9036f51013fe3ecdbb9d5578ef814178f89ba513e9343ca5a89e87ac486e64fc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"example.json").write <<~EOS
      {
        "cats": [{ "first": "Pixie" }, { "second": "Kitkat" }, { "third": "Misty" }]
      }
    EOS
    output = shell_output("#{bin}/jql --raw-output '\"cats\".[2:1].[0].\"third\"' example.json")
    assert_equal "Misty\n", output
  end
end
