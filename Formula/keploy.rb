class Keploy < Formula
  desc "Testing Toolkit creates test-cases and data mocks from API calls, DB queries"
  homepage "https://keploy.io"
  url "https://github.com/keploy/keploy/archive/refs/tags/v0.7.12.tar.gz"
  sha256 "8fd95b1736687e38c036bac03af8ebbc91029985dde1296441328c825d28510e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0307d54eb48fd1519908ded1b2a532070c4a4fbcc964eeba96ca6d78d4e8762a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea1524b61561bc081682e9cad537d108722f7bc2d4354dffbe6a114bb4c923ca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6c32bcd7b3b183621aaa1609f3939837f004090ab087462ab9aca1b795434bac"
    sha256 cellar: :any_skip_relocation, ventura:        "a0d3c6617c62ca6825967c0efb9168160ef90d0b3498a68d7ce1d9cd123bcbf6"
    sha256 cellar: :any_skip_relocation, monterey:       "ed20bc914036b3a89f833b432fa92a51f67cb3267b778636c6095b79b8d7eb56"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f580ddb771d1a5070b9ec6fb042126d23e3fb29ea8b5a682db31bef00b533d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6e26aac71939353ebe99c1f340a594c53c9116c0a224164614032de6c854489"
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
      sleep 2
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
