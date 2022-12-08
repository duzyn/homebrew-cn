class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.47.1.tar.gz"
  sha256 "8d451b658a78bf8aea12e9692ffc83869bf85aecaafdd2d556838bd0e3df0bbf"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1aeaf69bc22dbe89ec01c55ac74e3cab03775abc9ede198d6d3ca2d4ce5f558b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0fabcbde300506472abc7143f11ac3a02dd2a55760adef5cb0a4b4c2b944cc01"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6f70b75fe8e8b8bce5591aa89d4b91b0dc6b3ee99f2562e8f15c9da94d3158f9"
    sha256 cellar: :any_skip_relocation, ventura:        "6e74906bb3d9c7e4af17f734ad5d588413a2ff61a6725c27f5379d445308d3e6"
    sha256 cellar: :any_skip_relocation, monterey:       "5fbd3032be010cfd3ffe38cd1fdd8560df573f31b8b0cf9d590f42a2d30e3aa1"
    sha256 cellar: :any_skip_relocation, big_sur:        "28dac65c895cc8354886b0b32e97b66eb2bed3ecd20023d5a6d09b169edb0df7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df7a6786f866c762fd749e26cce9492e1981178e24f50ef4a4b96d604fdae742"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/open-policy-agent/opa/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
    system "./build/gen-man.sh", "man1"
    man.install "man1"

    generate_completions_from_executable(bin/"opa", "completion")
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
