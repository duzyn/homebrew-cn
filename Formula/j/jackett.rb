class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://mirror.ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2202.tar.gz"
  sha256 "2f79edf58e79437edc3157cef8c87f572cdce9d161d55c4a53fd506b32939bb5"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4a177b9b22694f99c66e4bbe56750890123409355cefbffdaeb69ab48d7e5f88"
    sha256 cellar: :any,                 arm64_sonoma:  "96ce48548a1021d59d4d7228a46dba60c31d454453aedc133204c7429b9f359c"
    sha256 cellar: :any,                 arm64_ventura: "cfd4ffe88756017a1d4c1093b987a7332749caa92db17d9f5318dfc787d6d9bd"
    sha256 cellar: :any,                 ventura:       "67ef4898e13bedaf545873e8e57e4719400fb1a83450139ac9c200445d9ec16c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8c5a8a8806438fd0f9f17439e14b5aedc654c21a7ebba02d1375c0ae1c263d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e9393124859899afa2c5c65b764e7e0fcad647e0087e69118c0dd653d9ff892"
  end

  depends_on "dotnet@8"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"

    dotnet = Formula["dotnet@8"]

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-self-contained
      --use-current-runtime
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
    working_dir opt_libexec
    log_path var/"log/jackett.log"
    error_log_path var/"log/jackett.log"
  end

  test do
    assert_match(/^Jackett v#{Regexp.escape(version)}$/, shell_output("#{bin}/jackett --version 2>&1; true"))

    port = free_port

    pid = fork do
      exec bin/"jackett", "-d", testpath, "-p", port.to_s
    end

    begin
      sleep 15
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
