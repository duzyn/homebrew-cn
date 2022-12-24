class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.2417.tar.gz"
  sha256 "5fd037eab35ac8be37f1bc6f8b0eeeb9c7459fc81e8ae3aacac3222f4449c2ed"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "874070d181bd8595d0f187f1db34cfb409a47bf5f6d0bce20fdfd9f89290871f"
    sha256 cellar: :any,                 arm64_monterey: "0d46170d05c01a756a4956776fd22529ea36f84102bcd2e97de4142492b21a75"
    sha256 cellar: :any,                 arm64_big_sur:  "2dd976c3cf83386447aaa62834a5828226d0902558e1e2bb81f85beb812b06e2"
    sha256 cellar: :any,                 ventura:        "e22d356d495fe164b2d093532a4cb153006a4f28b7f511cc0aa2ef551ccae593"
    sha256 cellar: :any,                 monterey:       "108eba590564f9a191c9507cf4c235dc96bf40b4f17cb7db6e28d33911aa2070"
    sha256 cellar: :any,                 big_sur:        "4bd8d217d4bf10263db19f0c4bfd7165be9d74c4047be2892cb94b3d86a2d171"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5937475c73f7461fb23f25cb91b9ebf353232107c23bfe477067528125a05e9"
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
