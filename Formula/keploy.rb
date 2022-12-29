class Keploy < Formula
  desc "Testing Toolkit creates test-cases and data mocks from API calls, DB queries"
  homepage "https://keploy.io"
  url "https://github.com/keploy/keploy/archive/refs/tags/v0.7.8.tar.gz"
  sha256 "370452533d2a835469dafd3286aa8f32572395b67f856a73d736b2ba0b447707"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d1db424e6d7e4264cb08dff86dad32398fbbcf49961f85735f898dbd3d2a4d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4d7ac8185a9590fea262d2921c2ba7047d4e61689a5a0816478253c7b6ae855"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d1842a95e81a3f09a569e23f0c064da457a9b64e982d0d2755de9349fdad374"
    sha256 cellar: :any_skip_relocation, ventura:        "752a3408b61dd758c8533745fd00ee68eb915fac6ff6e6934337b192b34cdf88"
    sha256 cellar: :any_skip_relocation, monterey:       "981f92914c0d4f23cde173674a1674b8222dbec3e2c473327aebb1a8118f64f3"
    sha256 cellar: :any_skip_relocation, big_sur:        "985dfe4e5a33d7d9ea68f88324d4197d2dd2284d393a6de7f5d78fca78daadfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f118391d5f4aff03a4eb3ba1b3572e74e7aa96f2ea7f8db8afca11e840977e5e"
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
