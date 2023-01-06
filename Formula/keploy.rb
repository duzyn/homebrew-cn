class Keploy < Formula
  desc "Testing Toolkit creates test-cases and data mocks from API calls, DB queries"
  homepage "https://keploy.io"
  url "https://github.com/keploy/keploy/archive/refs/tags/v0.7.11.tar.gz"
  sha256 "25f612f1d691bfb9d7c9892c39c4a4f475c823d1022d25278e2d5ddf0341fc59"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5760ea9aa9eb17a6dca401738db476770781efd1ba60ef9fa5c66ab713bf004"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef91283572fef3ba8ec05de34cf29e92308a9091cf8a1eaed02c5df519936de8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "09f8cdecd9247671b61aabcb7a5e6aeb757ea83aa1fda4b147095e1b68d949d4"
    sha256 cellar: :any_skip_relocation, ventura:        "25ca34502d45be82745c82fbecf626912c1e455c3d2988704abe039dd0767eeb"
    sha256 cellar: :any_skip_relocation, monterey:       "b9c723ccfe0bac5f671f339c252dedff8758ee2796702a893b9d5c58867b89d0"
    sha256 cellar: :any_skip_relocation, big_sur:        "e54c4953931345fe9250d424e497d6a42cc0d9f4bfe98549b8cd0bc697573b76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5152c9864792875964d9b8091f236b934921b6c91ed655211cc3ddfa8290c7a5"
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
