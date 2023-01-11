class Keploy < Formula
  desc "Testing Toolkit creates test-cases and data mocks from API calls, DB queries"
  homepage "https://keploy.io"
  url "https://github.com/keploy/keploy/archive/refs/tags/v0.7.14.tar.gz"
  sha256 "eb131601f953cb8f356cc3d8fdbb0b7bb39ff153589d0289455869961b4391da"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d3acb520d9fd90cb78b15445372c2df340b7dc44ac48a32237cbf81c558a76c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e004c6fd484e856d9a61276563b0cef62b767892500c6bdc5f40d71d83215bec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9607394891e451b94428ba2f95835eecdbae6f4e5f1c0ae97e22e279425f8108"
    sha256 cellar: :any_skip_relocation, ventura:        "8c13d55d2632d52e6728a861bc349a49456f946ec5dfba7a09ce3004e431d519"
    sha256 cellar: :any_skip_relocation, monterey:       "d0aac6d59ee3e52cbc6b371902294965a0e54b86e76b8948e09f550970eca55c"
    sha256 cellar: :any_skip_relocation, big_sur:        "b47c352b3060bfcf0c56ce0fdb66bd044bf73e848e4b2190b3213c29c353e681"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c83dc7c6c121f632259c004dac945144648dfdf604c5ebbbc40d5170637f45c"
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
