class AnycableGo < Formula
  desc "WebSocket server with action cable protocol"
  homepage "https://github.com/anycable/anycable-go"
  url "https://github.com/anycable/anycable-go/archive/v1.2.3.tar.gz"
  sha256 "d845c77689ccdf8e42a3ebf09ff1afefe2c65a95186c8d17757eb3a2ae80c5b0"
  license "MIT"
  head "https://github.com/anycable/anycable-go.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be5a229ee19093fd75fb8fe3779f99c18e1b9b0db64d8b52b831675daf94dd32"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a35d80477df5f90c5a7080b438e25d2b47fa216823455fca4f280e638582cd0b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "384d112c33b7bc1da9be0384492022211e2e3041a31ce6da0b1b4d6721b29c97"
    sha256 cellar: :any_skip_relocation, ventura:        "72b6f4b8ec75e6e4bb6a08649e583ea6e40b067d5adea1e767e3020130c5b514"
    sha256 cellar: :any_skip_relocation, monterey:       "77dadba9b7594110792122ec93de0a1ca372850ff95bf6874cce2c3b363f4088"
    sha256 cellar: :any_skip_relocation, big_sur:        "b0e6f4d3115ee2ff858de40ff305eaef6d84e7a6d8c34ab0131cb94d4695744a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "355f96dca4b909ca37a313722953674ef30d25ef65fe69908203793b3291a92d"
  end

  depends_on "go" => :build

  def install
    ldflags = %w[
      -s -w
    ]
    ldflags << if build.head?
      "-X github.com/anycable/anycable-go/utils.sha=#{version.commit}"
    else
      "-X github.com/anycable/anycable-go/utils.version=#{version}"
    end

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/anycable-go"
  end

  test do
    port = free_port
    pid = fork do
      exec "#{bin}/anycable-go --port=#{port}"
    end
    sleep 1
    output = shell_output("curl -sI http://localhost:#{port}/health")
    assert_match(/200 OK/m, output)
  ensure
    Process.kill("HUP", pid)
  end
end
