class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.2459.tar.gz"
  sha256 "3230b03941653ab1a194e00f786fb43b48740f3f924ac8ffd2345680d209ce9c"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3b4062e2bc9065e47adc2d30e14187f26bb2f7ee7b74eabbc7f38276b0c03e9a"
    sha256 cellar: :any,                 arm64_monterey: "62085a03a0c790d60f79345d5f0fb13cc75b72d64761da71e30c08693565b1a8"
    sha256 cellar: :any,                 arm64_big_sur:  "241924ac7d12935525c2efe17da9b161b451e9994520ead779f2cffd8596c55f"
    sha256 cellar: :any,                 ventura:        "550f9445d7df1ef7897df7112b34324a4f09a71965219bca244f7e15db7b8d21"
    sha256 cellar: :any,                 monterey:       "1baea0e2e207fdee82ac9030924cf6159f0d928b0fa56ba7e4451cf100d45f5e"
    sha256 cellar: :any,                 big_sur:        "29a5907ddf5b4dcc3e8249b4b136336a7a9d68c637efb189875927c5bd91682d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82aa551bc5c8e21e6178065b01a151b5855f2f46b4269021ac16d60d7529fa11"
  end

  depends_on "dotnet@6"

  def install
    dotnet = Formula["dotnet@6"]
    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --runtime #{os}-#{arch}
      --no-self-contained
    ]
    if build.stable?
      args += %W[
        /p:AssemblyVersion=#{version}
        /p:FileVersion=#{version}
        /p:InformationalVersion=#{version}
        /p:Version=#{version}
      ]
    end

    system "dotnet", "publish", "src/Jackett.Server", *args

    (bin/"jackett").write_env_script libexec/"jackett", "--NoUpdates",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  service do
    run opt_bin/"jackett"
    keep_alive true
    working_dir libexec
    log_path var/"log/jackett.log"
    error_log_path var/"log/jackett.log"
  end

  test do
    assert_match(/^Jackett v#{Regexp.escape(version)}$/, shell_output("#{bin}/jackett --version 2>&1; true"))

    port = free_port

    pid = fork do
      exec "#{bin}/jackett", "-d", testpath, "-p", port.to_s
    end

    begin
      sleep 10
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
