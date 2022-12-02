class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v6.18.1.tar.gz"
  sha256 "f97fe20248e0eb452f77e9b69f2fb1510b852152b3af4f9a8b20680c854888d1"
  license "GPL-3.0-or-later"
  head "https://github.com/xmrig/xmrig.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_ventura:  "96ba88c286be6e5b37025365e58b1a59b20e4ec19022489123b25ad32701e2c1"
    sha256                               arm64_monterey: "571d64dca5b8bde50a3e29316c82643bc363c6f8fd2d4a221b5c67de0c3aa097"
    sha256                               arm64_big_sur:  "2b61ffc4d5e7f8918f7f0c5bd1821a75da07777d652e861836968378fd0bbaec"
    sha256                               monterey:       "b32548656468b7383a18a53e002f6ec094809b476da7b3a70975aa87e00946f2"
    sha256                               big_sur:        "3c3d52dc162f372e33690b41ebda25b0cbf533ad0b3cc0b4a1621a9022841eb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64683cfd18f31c4998e204a59e5e1e6ef9280b706d73696494b272ac4b31acd8"
  end

  depends_on "cmake" => :build
  depends_on "hwloc"
  depends_on "libmicrohttpd"
  depends_on "libuv"
  depends_on "openssl@1.1"

  def install
    mkdir "build" do
      system "cmake", "..", "-DWITH_CN_GPU=OFF", *std_cmake_args
      system "make"
      bin.install "xmrig"
    end
    pkgshare.install "src/config.json"
  end

  test do
    require "pty"
    assert_match version.to_s, shell_output("#{bin}/xmrig -V")
    test_server = "donotexist.localhost:65535"
    output = ""
    args = %W[
      --no-color
      --max-cpu-usage=1
      --print-time=1
      --threads=1
      --retries=1
      --url=#{test_server}
    ]
    PTY.spawn(bin/"xmrig", *args) do |r, _w, pid|
      sleep 5
      Process.kill("SIGINT", pid)
      begin
        r.each_line { |line| output += line }
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end
    assert_match(/POOL #1\s+#{Regexp.escape(test_server)} algo auto/, output)
    pattern = "#{test_server} DNS error: \"unknown node or service\""
    if OS.mac?
      assert_match pattern, output
    else
      assert_match Regexp.union(pattern, "#{test_server} connect error: \"connection refused\""), output
    end
  end
end
