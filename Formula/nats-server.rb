class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/v2.9.9.tar.gz"
  sha256 "1a7face94149f366a2f3e55f80271bcad926ca82cb072854eeec0ebcdea74f45"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "efbaf309a3179e2773ec3d1de025ad24ae388102de7a20d14541c13082f62baa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5764543f662d03d18bea439b07d1e0e1380759f46833562721877cfb4dfa07a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "725666c88f95d92014b3b0bbf57660593d96fabb7938f5cb3f4968e3e27fe5c6"
    sha256 cellar: :any_skip_relocation, ventura:        "56115916ed20a9f91be1175539291c2f823398d942427cfb9f4102271436af16"
    sha256 cellar: :any_skip_relocation, monterey:       "b1bbed7a3ff4d2327d3e8116d4f6841448619380d60ff73c94b2b7325e844824"
    sha256 cellar: :any_skip_relocation, big_sur:        "9be4db9be552ef755d3d260ac05039c619c80386e9c713761d65e59b86fa1560"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "258db9977b5e2c26ca70f26a003806f522613b51b4768a3dd75eaf188dcf8614"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  service do
    run opt_bin/"nats-server"
  end

  test do
    port = free_port
    http_port = free_port
    fork do
      exec bin/"nats-server",
           "--port=#{port}",
           "--http_port=#{http_port}",
           "--pid=#{testpath}/pid",
           "--log=#{testpath}/log"
    end
    sleep 3

    assert_match version.to_s, shell_output("curl localhost:#{http_port}/varz")
    assert_predicate testpath/"log", :exist?
  end
end
