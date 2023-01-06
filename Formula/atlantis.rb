class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/v0.22.1.tar.gz"
  sha256 "694908404ce40384ed416e5cb94893a2da9ccf7d7414ffb66735a34385bcb0e9"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "53ab99d8565ccf537112f6d32a7e277125b4ff3bd0ca7204b744844fc27212ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00583be381de0d6f355a773bfa9c27025cde4e0d63d9f00628ffe348a4d78587"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0ad66667255e5ce72fdd0e88c9765ce3f56340af5b794cf2d6f45a78ec0f5465"
    sha256 cellar: :any_skip_relocation, ventura:        "eecca102b174602e20bcf4b10ec6ddb9bae97ab5324ff7be8acaf8213228cbc0"
    sha256 cellar: :any_skip_relocation, monterey:       "b56207b96ac9a7e1d3ec67ce270d40fa0add271a3bc39d1b15eceb39282f8fd4"
    sha256 cellar: :any_skip_relocation, big_sur:        "aeff94e647f17e2f66bb87e3c3a061a39291fca39c2f69225f15657c124e5941"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74a45db67b16d8d6cdaf714d880de5e3b474859ba459d845a8a7abb3113d28e6"
  end

  depends_on "go" => :build
  depends_on "terraform"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"atlantis", "version"
    port = free_port
    loglevel = "info"
    gh_args = "--gh-user INVALID --gh-token INVALID --gh-webhook-secret INVALID --repo-allowlist INVALID"
    command = bin/"atlantis server --atlantis-url http://invalid/ --port #{port} #{gh_args} --log-level #{loglevel}"
    pid = Process.spawn(command)
    system "sleep", "5"
    output = `curl -vk# 'http://localhost:#{port}/' 2>&1`
    assert_match %r{HTTP/1.1 200 OK}m, output
    assert_match "atlantis", output
    Process.kill("TERM", pid)
  end
end
