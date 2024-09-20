class TraefikAT2 < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://mirror.ghproxy.com/https://github.com/traefik/traefik/releases/download/v2.11.10/traefik-v2.11.10.src.tar.gz"
  sha256 "8d4fa675979dd2c2638fc5dfebd6c1c1bc9ab8888a70392328db688a785ffc8d"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(2\.\d+\.\d+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87bdf969e2cc41a9c64c82efaadb37176b4ef02591cd49c09a352dad8b17536b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e21e597c86d7135f84002810130a209f4df0ac0153545a66d7e4e25069b71701"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5f0fdda2aa0ba2acd8f8880f36e65cbe35e8b00bea487a49157a1412b08695d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "af343f51adcbe9a336490d6f4380faca6d29fce34cd3dab454698077d7fab830"
    sha256 cellar: :any_skip_relocation, ventura:       "3617dac2a39b891f385cd2c32bea50fc3ea13e6cb3bcff7693e112a083ec0d1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16151e944ff606cb37a50e49d948097c8397115f2d5bbfa88dd7d39bc19c20bc"
  end

  keg_only :versioned_formula

  # https://doc.traefik.io/traefik/deprecation/releases/
  disable! date: "2025-04-30", because: :unmaintained

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/traefik/traefik/v#{version.major}/pkg/version.Version=#{version}
    ]
    system "go", "generate"
    system "go", "build", *std_go_args(ldflags:, output: bin/"traefik"), "./cmd/traefik"
  end

  service do
    run [opt_bin/"traefik", "--configfile=#{etc}/traefik/traefik.toml"]
    keep_alive false
    working_dir var
    log_path var/"log/traefik.log"
    error_log_path var/"log/traefik.log"
  end

  test do
    ui_port = free_port
    http_port = free_port

    (testpath/"traefik.toml").write <<~EOS
      [entryPoints]
        [entryPoints.http]
          address = ":#{http_port}"
        [entryPoints.traefik]
          address = ":#{ui_port}"
      [api]
        insecure = true
        dashboard = true
    EOS

    begin
      pid = fork do
        exec bin/"traefik", "--configfile=#{testpath}/traefik.toml"
      end
      sleep 8
      cmd_ui = "curl -sIm3 -XGET http://127.0.0.1:#{http_port}/"
      assert_match "404 Not Found", shell_output(cmd_ui)
      sleep 1
      cmd_ui = "curl -sIm3 -XGET http://127.0.0.1:#{ui_port}/dashboard/"
      assert_match "200 OK", shell_output(cmd_ui)
    ensure
      Process.kill(9, pid)
      Process.wait(pid)
    end

    assert_match version.to_s, shell_output("#{bin}/traefik version 2>&1")
  end
end
