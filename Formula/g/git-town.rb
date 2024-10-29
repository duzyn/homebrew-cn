class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://mirror.ghproxy.com/https://github.com/git-town/git-town/archive/refs/tags/v16.5.0.tar.gz"
  sha256 "387d39c3a93e21e93c6bb43fa26478cdd6acd437e4ca433b8327a140f49509b7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93a5a6ff00b1dc3f6efd45d824b60522b8935e017feef83c41f13b2e91ae1cba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93a5a6ff00b1dc3f6efd45d824b60522b8935e017feef83c41f13b2e91ae1cba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "93a5a6ff00b1dc3f6efd45d824b60522b8935e017feef83c41f13b2e91ae1cba"
    sha256 cellar: :any_skip_relocation, sonoma:        "feb3e1a77692ee154659000916d4e8108d97a99cd576465a4269d55df9d437cf"
    sha256 cellar: :any_skip_relocation, ventura:       "feb3e1a77692ee154659000916d4e8108d97a99cd576465a4269d55df9d437cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3537a1e5840af3e10a70d6088546cde5f74a81fa66c5f6a103d5abd340979125"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/git-town/git-town/v#{version.major}/src/cmd.version=v#{version}
      -X github.com/git-town/git-town/v#{version.major}/src/cmd.buildDate=#{time.strftime("%Y/%m/%d")}
    ]
    system "go", "build", *std_go_args(ldflags:)

    # Install shell completions
    generate_completions_from_executable(bin/"git-town", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-town -V")

    system "git", "init"
    touch "testing.txt"
    system "git", "add", "testing.txt"
    system "git", "commit", "-m", "Testing!"

    system bin/"git-town", "config"
  end
end
