class Gitmux < Formula
  desc "Git status in tmux status bar"
  homepage "https://github.com/arl/gitmux"
  url "https://mirror.ghproxy.com/https://github.com/arl/gitmux/archive/refs/tags/v0.11.3.tar.gz"
  sha256 "6657fceefbee75565130ba971035610c7b71397a681fef2e58fc582b27fb5ed8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f00a81c72ddb108426e22f57fb19422ff25d09f91625a9197aa54936c90dbe7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f00a81c72ddb108426e22f57fb19422ff25d09f91625a9197aa54936c90dbe7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0f00a81c72ddb108426e22f57fb19422ff25d09f91625a9197aa54936c90dbe7"
    sha256 cellar: :any_skip_relocation, sonoma:        "f32a0d3a706c367ac660259897c27f52bc701c17e60b6de36ee7378787386d46"
    sha256 cellar: :any_skip_relocation, ventura:       "f32a0d3a706c367ac660259897c27f52bc701c17e60b6de36ee7378787386d46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d941b3ab9b157cfdf12c64a3b44608413f6da9c0d42936be807ae6232d3e5c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ce68bcc0391ad3a83e17de7f26df318ea67f44002c90309ee97bcbf6a9f3898"
  end

  depends_on "go" => :build
  depends_on "git" => :test
  depends_on "tmux"

  def install
    ldflags = "-s -w -X main.version=#{version}"

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitmux -V")

    system "git", "init", "--initial-branch=gitmux"

    # `gitmux` breaks our git shim by clearing the environment.
    ENV.prepend_path "PATH", Formula["git"].opt_bin
    assert_match '"LocalBranch": "gitmux"', shell_output("#{bin}/gitmux -dbg")
  end
end
