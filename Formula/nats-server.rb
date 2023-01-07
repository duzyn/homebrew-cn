class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/v2.9.11.tar.gz"
  sha256 "cd5afb9867042ebc62d2eec383ddf7332abf409f462776ec1432c94ec59fdf57"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5328f7b6d398ea1a368f9e585f6aa566375c2eb3e8caee23c48dfbbf6a39033a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dba6a3984098a0026a72582fe9044334be918c978603baf15296e73b39b9504f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a594a858fd7f002bf23d764a55f1b34b51d3cfb4fea83755ff6ca1820550bdad"
    sha256 cellar: :any_skip_relocation, ventura:        "1309bf18388a4981f905020a3762a89a25a6a50d83f9f5aed7871c0abc8fcfbe"
    sha256 cellar: :any_skip_relocation, monterey:       "df7c0eec4b715c16e6ce876f323f35100c53b2af3c9a60cf2cb7cd1848e256e0"
    sha256 cellar: :any_skip_relocation, big_sur:        "a36e672089d2fc548ff57b6eb19fda200fe8363bd528e94de3f9b7d66a97a95d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "914bb8c764cc9ee9d6c940063d16e1d0916ebf5eac8293452e80ca2dae40dec3"
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
