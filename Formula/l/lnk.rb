class Lnk < Formula
  desc "Git-native dotfiles management that doesn't suck"
  homepage "https://github.com/yarlson/lnk"
  url "https://mirror.ghproxy.com/https://github.com/yarlson/lnk/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "bf9f329d194a4f267f2d8684fc658c862ee003f712ba58b75ed970f6ea0368a8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e73f971d5a55b4799985bea0a4661b6542d3e63ca449a8d525fd2acb3ba07fd6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e73f971d5a55b4799985bea0a4661b6542d3e63ca449a8d525fd2acb3ba07fd6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e73f971d5a55b4799985bea0a4661b6542d3e63ca449a8d525fd2acb3ba07fd6"
    sha256 cellar: :any_skip_relocation, sonoma:        "24600737f39e0f07f3480e76879ee85493f79df4ef085336a0497dcdd8899ef3"
    sha256 cellar: :any_skip_relocation, ventura:       "24600737f39e0f07f3480e76879ee85493f79df4ef085336a0497dcdd8899ef3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc419675469b021bdb8a161a3fdc541d450c06e1d75fd58817d9aa6c51b0b3e7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.buildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lnk --version")
    assert_match "Lnk repository not initialized", shell_output("#{bin}/lnk list 2>&1", 1)
  end
end
