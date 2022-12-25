class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.2430.tar.gz"
  sha256 "906bd2e45b256f057486bf22495326c19c7d3fef95815249c603fd003c82b193"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "213c2034da86b4cda4ce0d253e4d20a3bc834aee96c3eff7c173b54c3aa4cddd"
    sha256 cellar: :any,                 arm64_monterey: "0664e98c409adfe19ec33a28cb65908aeab948675d00c2349b24c23617dfd0ae"
    sha256 cellar: :any,                 arm64_big_sur:  "b426607be779746da6c0d6c93eea7261b5092d772383f4e573036f37374d3528"
    sha256 cellar: :any,                 ventura:        "45b09b201bdb4a5e60efbba7966d6b35445d240026ca7043afd19572b983b0d0"
    sha256 cellar: :any,                 monterey:       "30a2e70421256b6e15c45d1a9cb1883f865117dc712816a21fc1ee611a0816fa"
    sha256 cellar: :any,                 big_sur:        "d737a677a28da11c67a097c36b3668b50bedd33c40aef792f167ae353b88a3de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8199e3b4128277ff291e454f6695b65da16f98b84f2ffb88c5c3968a3239a113"
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
