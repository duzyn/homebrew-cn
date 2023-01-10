class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.48.0.tar.gz"
  sha256 "73e499c9486784940e4d65d2fd1b23423c93fbf0dccd671289169ddec1141563"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bddc7408aab9aedd514aefae784e6dee95aae6d8969136d7b0f083e72cf596f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c75b8d49cc561867cf3f49de929b1312b84e38317661cb65c8e108f33f293fb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3eeff9e390b673d47f25b866dea41c3ce2b9de52468385bcca2e9ac9fed65d3f"
    sha256 cellar: :any_skip_relocation, ventura:        "934ebef81858defaa6486febbb9275bab9e8ec25249d5f9dc9a86bb426675aeb"
    sha256 cellar: :any_skip_relocation, monterey:       "5529727ecf3e094b130aa928b3572ba256691c85e4b524a6d8b0ec56ba2506ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "584afab3e9e97897160cda01a4979f8ff55df2e58169a9e011384f2a46cf531c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c4f684fea2e5b75f11f92d66b23a7a3ff82e6db7a2638e326714784dc05470a"
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
