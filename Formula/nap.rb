class Nap < Formula
  desc "Code snippets in your terminal"
  homepage "https://github.com/maaslalani/nap"
  url "https://github.com/maaslalani/nap/archive/v0.1.1.tar.gz"
  sha256 "2954577d2bd99c1114989d31e994d7bef0f1c934795fc559b7c90f6370d9f98b"
  license "MIT"
  head "https://github.com/maaslalani/nap.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "aa1b0f4cfc407cb72526136b5f94197e3aca5150b790c7d35ea8034792e2597d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match "misc/Untitled Snippet.go", shell_output("#{bin}/nap list")
  end
end
