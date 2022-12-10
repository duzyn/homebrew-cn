class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.2352.tar.gz"
  sha256 "7a7d8152abdc274ceae8a55e88d6b923fa91ef8b8fdf07a46bb2eadf12cdfe12"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d30449c9c7cbc6a1467e5f9fb989763a06cc968ed7171d3843a4a65f4126f43f"
    sha256 cellar: :any,                 arm64_monterey: "aa1df7a9cddd612b5f79e990bee01b5afe9101c602c0c8e4127130b061db9c3d"
    sha256 cellar: :any,                 arm64_big_sur:  "a0a82a18280735990910b0a101927207cb135dca95ae6e8f233faeff69c3be99"
    sha256 cellar: :any,                 ventura:        "365b655219f25f0223c4b94d2b9ff20f643b313d8d9ec09b46d8e961fc949d81"
    sha256 cellar: :any,                 monterey:       "1988a1fdd6b1ddf00d3d11ebd4aa99b22bcc2a2ee9924dd6a1e61162cc822745"
    sha256 cellar: :any,                 big_sur:        "d529124b9ff0aa4421d176f07f98990db8d26de70c414b3d8cbf33a903ffcb55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad73a8b7ac7683477a383ead0a321cf113fbcd73e3615fe183ea40e523eeb2df"
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
