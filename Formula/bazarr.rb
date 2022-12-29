require "language/node"

class Bazarr < Formula
  include Language::Python::Virtualenv

  desc "Companion to Sonarr and Radarr for managing and downloading subtitles"
  homepage "https://www.bazarr.media"
  url "https://ghproxy.com/github.com/morpheus65535/bazarr/releases/download/v1.1.3/bazarr.zip"
  sha256 "8ede84f95b43ec974f20975606456b43288d7d3eefc52633e245eb15001da571"
  license "GPL-3.0-or-later"
  head "https://github.com/morpheus65535/bazarr.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee1e9c2217ba231bab3415553169f05eb967e4a95e188409bb5146573e1e1197"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8d1799068b8dbf5ae6160ad75d7f61b573d5d5711f2af597ea67d1d698a68fd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ed9cab5d1486872761e0b0201ff420084811ad3ec1db112eff02e5567295e55"
    sha256 cellar: :any_skip_relocation, ventura:        "5746d5a830c23966132a3ea7c81d817545ace92f9fc6827e398b1e530b6aa7b9"
    sha256 cellar: :any_skip_relocation, monterey:       "89b5e52241594d4388d15b90c1f38ec238956a0dd9855b6b579355b1e8c1e69d"
    sha256 cellar: :any_skip_relocation, big_sur:        "e5f72c872c3c73aeb391f55cd1e721f655f7ef4a2750aacf2e14defc4610cff6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b0592eac170c27e128e9e2ed8aee0df2dc168d8f9e0dfb471866c77292d4193"
  end

  depends_on "node" => :build
  depends_on "ffmpeg"
  depends_on "gcc"
  depends_on "numpy"
  depends_on "pillow"
  depends_on "python@3.11"
  depends_on "unar"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "zlib"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/70/bb/7a2c7b4f8f434aa1ee801704bf08f1e53d7b5feba3d5313ab17003477808/lxml-4.9.1.tar.gz"
    sha256 "fe749b052bb7233fe5d072fcb549221a8cb1a16725c47c37e42b0b9cb3ff2c3f"
  end

  resource "webrtcvad-wheels" do
    url "https://files.pythonhosted.org/packages/59/d9/17fe64f981a2d33c6e95e115c29e8b6bd036c2a0f90323585f1af639d5fc/webrtcvad-wheels-2.0.11.post1.tar.gz"
    sha256 "aa1f749b5ea5ce209df9bdef7be9f4844007e630ac87ab9dbc25dda73fd5d2b7"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/Language::Python.site_packages("python3.11")
    venv = virtualenv_create(libexec, "python3.11")

    venv.pip_install resources

    if build.head?
      # Build front-end.
      cd buildpath/"frontend" do
        system "npm", "install", *Language::Node.local_npm_install_args
        system "npm", "run", "build"
      end
    end

    # Stop program from automatically downloading its own binaries.
    binaries_file = buildpath/"bazarr/utilities/binaries.json"
    rm binaries_file
    binaries_file.write "[]"

    libexec.install Dir["*"]
    (bin/"bazarr").write_env_script libexec/"bin/python", "#{libexec}/bazarr.py",
      NO_UPDATE:  "1",
      PATH:       "#{Formula["ffmpeg"].opt_bin}:#{HOMEBREW_PREFIX/"bin"}:$PATH",
      PYTHONPATH: ENV["PYTHONPATH"]

    (libexec/"data").install_symlink pkgetc => "config"
  end

  def post_install
    pkgetc.mkpath
  end

  service do
    run opt_bin/"bazarr"
    keep_alive true
    require_root true
    log_path var/"log/bazarr.log"
    error_log_path var/"log/bazarr.log"
  end

  test do
    require "open3"
    require "timeout"

    system "#{bin}/bazarr", "--help"

    port = free_port

    Open3.popen3("#{bin}/bazarr", "--config", testpath, "-p", port.to_s) do |_, _, stderr, wait_thr|
      Timeout.timeout(30) do
        stderr.each do |line|
          refute_match "ERROR", line
          break if line.include? "BAZARR is started and waiting for request on http://0.0.0.0:#{port}"
        end
        assert_match "<title>Bazarr</title>", shell_output("curl --silent http://localhost:#{port}")
      end
    ensure
      Process.kill "TERM", wait_thr.pid
      Process.wait wait_thr.pid
    end
  end
end
