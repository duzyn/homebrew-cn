class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://mirror.ghproxy.com/https://github.com/influxdata/telegraf/archive/refs/tags/v1.36.1.tar.gz"
  sha256 "2478f4c9543300ed44cc0a3329e5a4c6095d9a6eae86aa2deab4ff9d19c1fdd5"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b2d949668587cc97f75110f0aef9ac7781acf9e5dfce5143ed536eddbb615a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8093266be210755d05e755c87ce2b48ec5691c51dfbf63232eb0ac6514f4e20"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5c81df43a6ead06dd0b5491d3cd5711f564af7bf950f9a98b685275fb80793f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "3408b33d406a520c72f98eecc375af561b16414d5c7d7330a68433c6cda552fb"
    sha256 cellar: :any_skip_relocation, ventura:       "83582771b37e6690fe36b08dc25f849d6c697aabdb7e84cc450ddc8d7f4b47b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48c246dbe0394ac69f2ab6e3fe6a23fa814e6e74d58aa26d0d907d1da679b1cd"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/influxdata/telegraf/internal.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/telegraf"

    (buildpath/"telegraf.conf").write Utils.safe_popen_read(bin/"telegraf", "config")
    etc.install "telegraf.conf"
    # Create directory for additional user configurations
    (etc/"telegraf.d").mkpath
  end

  service do
    run [opt_bin/"telegraf", "-config", etc/"telegraf.conf", "-config-directory", etc/"telegraf.d"]
    keep_alive true
    working_dir var
    log_path var/"log/telegraf.log"
    error_log_path var/"log/telegraf.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/telegraf --version")
    (testpath/"config.toml").write shell_output("#{bin}/telegraf -sample-config")
    system bin/"telegraf", "-config", testpath/"config.toml", "-test", "-input-filter", "cpu:mem"
  end
end
