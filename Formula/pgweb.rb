class Pgweb < Formula
  desc "Web-based PostgreSQL database browser"
  homepage "https://sosedoff.github.io/pgweb/"
  url "https://github.com/sosedoff/pgweb/archive/v0.12.0.tar.gz"
  sha256 "105975efc653126c1d66c00124b4ed0a3a15453d5d736dbdb61a3ad18278df5b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3dac2ba1375927607407d52016c49f3e44885cfaebeeecf99bb0789db6efdf04"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "abce759235caacc51c4b49f67ce974337f844426deee101b1f804cadddf16fc5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "84574ef696919a4fb9c2173af955420898958a86c875082c2bf724289c132f0f"
    sha256 cellar: :any_skip_relocation, ventura:        "dc765e66c229bdaedeca3a547f6bd21b7979bffaef9a8c3b7f052eaab0934407"
    sha256 cellar: :any_skip_relocation, monterey:       "355ebe82c7447d718ddf9f02dd290f99db20aa829fcba8a7d101de49b58e5683"
    sha256 cellar: :any_skip_relocation, big_sur:        "b9651c5b26d9e237d22fd65ab51a5bb86fdf72fd4e23b8d05aa1a405c49f34d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e935fa60589448d1f76b4a740656c8cd020df3f36084f2004c6c4ae00a7b50c3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/sosedoff/pgweb/pkg/command.BuildTime=#{time.iso8601}
      -X github.com/sosedoff/pgweb/pkg/command.GoVersion=#{Formula["go"].version}
    ].join(" ")

    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    port = free_port

    begin
      pid = fork do
        exec bin/"pgweb", "--listen=#{port}",
                          "--skip-open",
                          "--sessions"
      end
      sleep 2
      assert_match "\"version\":\"#{version}\"", shell_output("curl http://localhost:#{port}/api/info")
    ensure
      Process.kill("TERM", pid)
    end
  end
end
