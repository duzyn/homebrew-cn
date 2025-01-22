class Sshs < Formula
  desc "Graphical command-line client for SSH"
  homepage "https://github.com/quantumsheep/sshs"
  url "https://mirror.ghproxy.com/https://github.com/quantumsheep/sshs/archive/refs/tags/4.6.0.tar.gz"
  sha256 "58e104dac3a1515f79421b46b22079cc443261c15ca5b97fb025a00775d600ff"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "deb83c528f4fbdfeaafa1a01110b65e82945eeac90fedf09e15294560091969d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1afde78a9e24931382df136f06b637179a9d304415c6239b57fb7ce5e4f7349c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a47ef5cb4c8c2b0f25859e52b4f48a62909fe81386f8e1529fe279f6296c0f4a"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d8ec24a929a1be1d22460ba0bb7cc45d21ad6cab0ded1391df9587d646a9a7a"
    sha256 cellar: :any_skip_relocation, ventura:       "cf31ca58164c499dac8e7813a3048cf39d18de65ba7a2dea1a9ca53c1a6dc1b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d657c8b83244e0d4d2fc88ab1c3ca7372cf9ffdee43496d60c61f3c7b8627c2"
  end

  depends_on "rust" => :build

  # version patch, upstream pr ref, https://github.com/quantumsheep/sshs/pull/115
  patch do
    url "https://github.com/quantumsheep/sshs/commit/de24632c4a83beb82ca041f4cfaa5e1c534993b3.patch?full_index=1"
    sha256 "40c0e71b5fd3edc06250f1e4775395c49607dca7c3da6c36065e0c084a8e2b9f"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_equal "sshs #{version}", shell_output(bin/"sshs --version").strip

    (testpath/".ssh/config").write <<~EOS
      Host "Test"
        HostName example.com
        User root
        Port 22
    EOS

    require "pty"
    require "io/console"

    ENV["TERM"] = "xterm"

    PTY.spawn(bin/"sshs") do |r, w, _pid|
      r.winsize = [80, 40]
      sleep 1

      # Search for Test host
      w.write "Test"
      sleep 1

      # Quit
      w.write "\003"
      sleep 1

      begin
        r.read
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end
  end
end
