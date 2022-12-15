class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "https://tile38.com/"
  url "https://github.com/tidwall/tile38.git",
      tag:      "1.30.1",
      revision: "cf745b17d6afcb80c5a2f75bcb72c51b9bd44a1a"
  license "MIT"
  head "https://github.com/tidwall/tile38.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "30d507633db19c272a95e8dab1c90f371b2c472bb8155a82cc840ce6fa1b3f42"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aaf134bea5ea6d6ec8f3f846b6842e612ad718ec5479814c580d5bfc33e444c3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6f299742faa317bc4fb3fa01888e8ed0df93546c82a14593ff8fccc17d059080"
    sha256 cellar: :any_skip_relocation, ventura:        "2477e8eed400d80ce0d6617eaec161a6d32b1c23eea27e3f719afe227c45e94e"
    sha256 cellar: :any_skip_relocation, monterey:       "50744c26a767eabbf7985988338a423c369b36134ee39f5987ca85c85013dc5d"
    sha256 cellar: :any_skip_relocation, big_sur:        "ca0c92609be8a4d39d86d54d0be2fd7cf9db478465121ab4c5c7745299ff6f8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "557d98338981e481d89128a3fbb2ef7c07c1894fd7a2eebe88f12298e7a141e4"
  end

  depends_on "go" => :build

  def datadir
    var/"tile38/data"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/tidwall/tile38/core.Version=#{version}
      -X github.com/tidwall/tile38/core.GitSHA=#{Utils.git_short_head}
    ].join(" ")

    system "go", "build", *std_go_args(ldflags: ldflags), "-o", bin/"tile38-server", "./cmd/tile38-server"
    system "go", "build", *std_go_args(ldflags: ldflags), "-o", bin/"tile38-cli", "./cmd/tile38-cli"
  end

  def post_install
    # Make sure the data directory exists
    datadir.mkpath
  end

  def caveats
    <<~EOS
      To connect: tile38-cli
    EOS
  end

  service do
    run [opt_bin/"tile38-server", "-d", var/"tile38/data"]
    keep_alive true
    working_dir var
    log_path var/"log/tile38.log"
    error_log_path var/"log/tile38.log"
  end

  test do
    port = free_port
    pid = fork do
      exec "#{bin}/tile38-server", "-q", "-p", port.to_s
    end
    sleep 2
    # remove `$408` in the first line output
    json_output = shell_output("#{bin}/tile38-cli -p #{port} server")
    tile38_server = JSON.parse(json_output)

    assert_equal tile38_server["ok"], true
    assert_predicate testpath/"data", :exist?
  ensure
    Process.kill("HUP", pid)
  end
end
