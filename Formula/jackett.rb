class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.2495.tar.gz"
  sha256 "a50790fc897f1ab0c5a4a8e0322ebdddf69ec4aa45d6e24fb4bbdbbca3bbdb09"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d70cecf90b281ffffb5a25497348f263e40e32ff51d3534a3ea7cb8085610de4"
    sha256 cellar: :any,                 arm64_monterey: "27d4dad4aad48c888d564876c982dcd058b776f20a263a7cb40a45cecb0fe212"
    sha256 cellar: :any,                 arm64_big_sur:  "edeb7fe6c402685c8e19162c50a077857edf1e190963b855a5843442c28048ea"
    sha256 cellar: :any,                 ventura:        "bf07f28a6213a2ff80d2bbeee6752d689a2bc94813105314f803d0a33508ccc0"
    sha256 cellar: :any,                 monterey:       "812fea2ec13f87895175d1e01f5c4330e1e980ec0281252415f14f7545df2a53"
    sha256 cellar: :any,                 big_sur:        "a2786c84928c9f27c4491e51932e5398fd80304e9c5307e0bab3488db5e99ed0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9adb1e96a5db076b0bc0a1e6008cf4707815235eb10acc792971f5ff72360cb4"
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
