class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.2444.tar.gz"
  sha256 "c68a23a76d6406d13738699280a08436db6610d78bd74a65e4d5015225aa8d06"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5c42a50b5043338b985a868e91fbd8fe2169ce3908c6823e7447dc109044ce94"
    sha256 cellar: :any,                 arm64_monterey: "373357ca1deea7d9d276eafd241788c89ad83baa66cc339cce96ed621ff93c92"
    sha256 cellar: :any,                 arm64_big_sur:  "baf5c4fc046b187b6bcfc52ccd8182e6c21ec1b71dcabf69e6cca51e1a3fd5b4"
    sha256 cellar: :any,                 ventura:        "8f417d5c607e9c0566de31f750a27fc6e59d3e9de18cb879cde2e44831d04721"
    sha256 cellar: :any,                 monterey:       "552bcfd897e10357c3cb913d3d4e75f9666e4ba303a76f62b980f0f16c8ad1ea"
    sha256 cellar: :any,                 big_sur:        "cfdd3b0846f1bbd21101ff6a5095dfc53033a196b85eefca199bb02233f7d1fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75965c17505cb421f3c58dad99530d74c037182750618a3f465c2adf7dc50fab"
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
