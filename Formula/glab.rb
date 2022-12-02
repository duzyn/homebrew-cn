class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli/-/archive/v1.23.1/cli-v1.23.1.tar.gz"
  sha256 "62eb94245aba3211ea10a5bad6a350d5bc77e1a44550470240f7a1dc0edf73ab"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c491b4ac275efa96a46aa21b1037f8c1486cf365ac39822f11d9787c3eb105c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f48a2343e148f8c85f20e339cb86dff1c77eb2ee6712be4a119c94cd509e465"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "33eb5184c022d829d328c289578c0a2f7e65620dce9bcd69f5e7e51479484125"
    sha256 cellar: :any_skip_relocation, ventura:        "bd935eb0803fe200514e38f04750f94654bb96bf1c323730e50177c33de0d6d9"
    sha256 cellar: :any_skip_relocation, monterey:       "a399f51c22259cd0e31f2d1efaffbfb229906c1162d9686ec5ebb718acba2579"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e82cfe4a57cf20f18d7fca6f1a27db945f2f5a0d1a895291df6c725e4c16d0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45f365d91554ebdc289be37cec0561c67dc5d47672cdd7c34df05e09db25d329"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.mac?

    system "make", "GLAB_VERSION=#{version}"
    bin.install "bin/glab"
    generate_completions_from_executable(bin/"glab", "completion", "--shell")
  end

  test do
    system "git", "clone", "https://gitlab.com/profclems/test.git"
    cd "test" do
      assert_match "Clement Sam", shell_output("#{bin}/glab repo contributors")
      assert_match "This is a test issue", shell_output("#{bin}/glab issue list --all")
    end
  end
end
