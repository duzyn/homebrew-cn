class Mediamtx < Formula
  desc "Zero-dependency real-time media server and media proxy"
  homepage "https://github.com/bluenviron/mediamtx"
  # need to use the tag to generate the version info
  url "https://github.com/bluenviron/mediamtx.git",
      tag:      "v1.12.2",
      revision: "de46a288acf3d9189b25023a0fea1b2fd22ec14d"
  license "MIT"
  head "https://github.com/bluenviron/mediamtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff28231b6bf33f10fef4cbd76b6fe4506ed47420cd6a793085ab951ba35571d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff28231b6bf33f10fef4cbd76b6fe4506ed47420cd6a793085ab951ba35571d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ff28231b6bf33f10fef4cbd76b6fe4506ed47420cd6a793085ab951ba35571d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "11c841a67ce3ce7c44790d10884dad4595415f5f76199c23e91dc1560d9c3840"
    sha256 cellar: :any_skip_relocation, ventura:       "11c841a67ce3ce7c44790d10884dad4595415f5f76199c23e91dc1560d9c3840"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc03ae80f11ec30f4efaaa8c99cd58e729d18e3a6a2cd076d5611f8f014a63e3"
  end

  depends_on "go" => :build

  def install
    system "go", "generate", "./..."
    system "go", "build", *std_go_args(ldflags: "-s -w")

    # Install default config
    (etc/"mediamtx").install "mediamtx.yml"
  end

  def post_install
    (var/"log/mediamtx").mkpath
  end

  service do
    run [opt_bin/"mediamtx", etc/"mediamtx/mediamtx.yml"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/mediamtx/output.log"
    error_log_path var/"log/mediamtx/error.log"
  end

  test do
    port = free_port

    # version report has some issue, https://github.com/bluenviron/mediamtx/issues/3846
    assert_match version.to_s, shell_output("#{bin}/mediamtx --help")

    mediamtx_api = "127.0.0.1:#{port}"
    pid = fork do
      exec({ "MTX_API" => "yes", "MTX_APIADDRESS" => mediamtx_api }, bin/"mediamtx", etc/"mediamtx/mediamtx.yml")
    end
    sleep 3

    # Check API output matches configuration
    curl_output = shell_output("curl --silent http://#{mediamtx_api}/v3/config/global/get")
    assert_match "\"apiAddress\":\"#{mediamtx_api}\"", curl_output
  ensure
    Process.kill("TERM", pid)
    Process.wait pid
  end
end
