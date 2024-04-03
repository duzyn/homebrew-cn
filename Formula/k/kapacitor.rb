class Kapacitor < Formula
  desc "Open source time series data processor"
  homepage "https://github.com/influxdata/kapacitor"
  license "MIT"
  head "https://github.com/influxdata/kapacitor.git", branch: "master"

  stable do
    url "https://github.com/influxdata/kapacitor.git",
        tag:      "v1.7.3",
        revision: "43be9330273f227c6b5495a97019483577c542a7"

    # build patch to upgrade flux so that it can be built with rust 1.72.0+
    # upstream PR ref, https://github.com/influxdata/kapacitor/pull/2811
    patch do
      url "https://github.com/influxdata/kapacitor/commit/1bc086f38b5164813c0f5b0989045bd21d543377.patch?full_index=1"
      sha256 "38ab4f97dfed87cde492c0f1de372dc6563bcdda10741cace7a99f8d3ab777b6"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ad8297a4ea43e8828f469d2f6b7ce51e3cdd400c433bb0704d956f785c8edf60"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "342e715c78a0d7e7d561f1f007b1e0c5953059d1c1a0217348a3a6509c8b410c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98cb7ab8d8b7d46f1bf4be85a0777ce062b1c3172ae1b0b643654908c08972d2"
    sha256 cellar: :any_skip_relocation, sonoma:         "695d66d7615886b75bb3ffdfe6793c606a6d1536f8bcc9fca8367bcec8f3ef76"
    sha256 cellar: :any_skip_relocation, ventura:        "bbb3b1795df03094af6882ff6bc626c69f7d45f7ddcc2e74302d85cc2b9a8d7e"
    sha256 cellar: :any_skip_relocation, monterey:       "42eceee9e2fd334fd15d3ea2d07f6e45c5e9d7e04e1913a8fe2e3d4cff53373b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4531514860c13fcd4ff0b047d867e3730d14554de778b951a0aad875bcd8d1f2"
  end

  depends_on "go" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build # for `pkg-config-wrapper`
  end

  # NOTE: The version here is specified in the go.mod of kapacitor.
  # If you're upgrading to a newer kapacitor version, check to see if this needs upgraded too.
  resource "pkg-config-wrapper" do
    url "https://mirror.ghproxy.com/https://github.com/influxdata/pkg-config/archive/refs/tags/v0.2.12.tar.gz"
    sha256 "23b2ed6a2f04d42906f5a8c28c8d681d03d47a1c32435b5df008adac5b935f1a"
  end

  def install
    resource("pkg-config-wrapper").stage do
      system "go", "build", *std_go_args, "-o", buildpath/"bootstrap/pkg-config"
    end
    ENV.prepend_path "PATH", buildpath/"bootstrap"

    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags.join(" ")), "./cmd/kapacitor"
    system "go", "build", *std_go_args(ldflags: ldflags.join(" ")), "-o", bin/"kapacitord", "./cmd/kapacitord"

    inreplace "etc/kapacitor/kapacitor.conf" do |s|
      s.gsub! "/var/lib/kapacitor", "#{var}/kapacitor"
      s.gsub! "/var/log/kapacitor", "#{var}/log"
    end

    etc.install "etc/kapacitor/kapacitor.conf" => "kapacitor.conf"
  end

  def post_install
    (var/"kapacitor/replay").mkpath
    (var/"kapacitor/tasks").mkpath
  end

  service do
    run [opt_bin/"kapacitord", "-config", etc/"kapacitor.conf"]
    keep_alive successful_exit: false
    error_log_path var/"log/kapacitor.log"
    log_path var/"log/kapacitor.log"
    working_dir var
  end

  test do
    (testpath/"config.toml").write shell_output("#{bin}/kapacitord config")

    inreplace testpath/"config.toml" do |s|
      s.gsub! "disable-subscriptions = false", "disable-subscriptions = true"
      s.gsub! %r{data_dir = "/.*/.kapacitor"}, "data_dir = \"#{testpath}/kapacitor\""
      s.gsub! %r{/.*/.kapacitor/replay}, "#{testpath}/kapacitor/replay"
      s.gsub! %r{/.*/.kapacitor/tasks}, "#{testpath}/kapacitor/tasks"
      s.gsub! %r{/.*/.kapacitor/kapacitor.db}, "#{testpath}/kapacitor/kapacitor.db"
    end

    http_port = free_port
    ENV["KAPACITOR_URL"] = "http://localhost:#{http_port}"
    ENV["KAPACITOR_HTTP_BIND_ADDRESS"] = ":#{http_port}"
    ENV["KAPACITOR_INFLUXDB_0_ENABLED"] = "false"
    ENV["KAPACITOR_REPORTING_ENABLED"] = "false"

    begin
      pid = fork do
        exec "#{bin}/kapacitord -config #{testpath}/config.toml"
      end
      sleep 20
      shell_output("#{bin}/kapacitor list tasks")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
