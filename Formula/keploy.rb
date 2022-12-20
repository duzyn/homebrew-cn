class Keploy < Formula
  desc "Testing Toolkit creates test-cases and data mocks from API calls, DB queries"
  homepage "https://keploy.io"
  url "https://github.com/keploy/keploy/archive/refs/tags/v0.7.6.tar.gz"
  sha256 "69b586f6a2ac8e28966d534e93108d493ca21e88454bf1f1e53a09295dc14eb3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cfe9f214a44146c7ad323b766cb2b33ef68f63e878e3cf8531796e0f79e24a1a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "900be33dcc38f02cec305b09c6a31cd3ac5d60b58d9967da33ff57d9298bd03a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "575703af492c8dd564636788d0e8e277d33b45e4c8117369d093aeea4d41d315"
    sha256 cellar: :any_skip_relocation, ventura:        "6b5d2a855b4a33c4496eef48bb0adff918f6e9926c79717b1e8faa87aa5ea9a9"
    sha256 cellar: :any_skip_relocation, monterey:       "e26474bce38f8539caf5ad5c6d2651eef3bfb9b9f1251c62090b6152a9044ba7"
    sha256 cellar: :any_skip_relocation, big_sur:        "e563eec1d512495cd27974a83c5904fc405dc1fa0f51599eae30e204a0a65cee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8272d486e330ec1c7ef8243894848ffac7355c3b88c9f5900ab25a95c7f9c57a"
  end

  depends_on "gatsby-cli" => :build
  depends_on "go" => :build
  depends_on "node"

  resource("ui") do
    url "https://github.com/keploy/ui/archive/refs/tags/0.1.0.tar.gz"
    sha256 "d12cdad7fa1c77b8bd755030e9479007e9fcb476fecd0fa6938f076f6633028e"
  end

  def install
    resource("ui").stage do
      system "npm", "install", "--legacy-peer-deps", *Language::Node.local_npm_install_args
      system "gatsby", "build"
      buildpath.install "./public"
    end
    cp_r "public", "web", remove_destination: true
    system "go", "build", *std_go_args, "./cmd/server"
  end

  test do
    require "pty"

    port = free_port
    env = { "PORT" => port.to_s }
    executable = bin/"keploy"

    output = ""
    PTY.spawn(env, executable) do |r, _w, pid|
      sleep 1
      Process.kill("TERM", pid)
      begin
        r.each_line { |line| output += line }
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end
    assert_match("keploy started at port #{port}", output)
  end
end
