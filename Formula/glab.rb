class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli/-/archive/v1.23.1/cli-v1.23.1.tar.gz"
  sha256 "62eb94245aba3211ea10a5bad6a350d5bc77e1a44550470240f7a1dc0edf73ab"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "trunk"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76d9c85a165f5f164579071bd3b33ac39f06ed50884ce99f3b5296da00af7d4d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11d861d400951cd4cf0642fb3bc508997c69a2ae838585df3e585b334ec09e54"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2ee917d9e6f848ce173c2a8751df12a9651fcbf280e2ed8279f77b77db00d3d8"
    sha256 cellar: :any_skip_relocation, ventura:        "62f4cba521d9e490fcf7602a7f20ca87a87b8616738b9bbcfbdc6762ec72221e"
    sha256 cellar: :any_skip_relocation, monterey:       "035371cf97a4683a202db68a47e71f37d43c571226a777314b2348ab566e4261"
    sha256 cellar: :any_skip_relocation, big_sur:        "db956c3b76f987ef3d9d01b92aed24fb9de27983a76fbecd1534c5a2218a9ffa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f091e802582ad98a1364172a27e84a4451af779ffb8c6d82edc543cebb96726"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.mac?

    system "make", "GLAB_VERSION=#{version}"
    bin.install "bin/glab"
    generate_completions_from_executable(bin/"glab", "completion", "--shell")
  end

  test do
    system "git", "clone", "https://gitlab.com/cli-automated-testing/homebrew-testing.git"
    cd "homebrew-testing" do
      assert_match "Matt Nohr", shell_output("#{bin}/glab repo contributors")
      assert_match "This is a test issue", shell_output("#{bin}/glab issue list --all")
    end
  end
end
