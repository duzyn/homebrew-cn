class Questdb < Formula
  desc "Time Series Database"
  homepage "https://questdb.io"
  url "https://mirror.ghproxy.com/https://github.com/questdb/questdb/releases/download/8.1.1/questdb-8.1.1-no-jre-bin.tar.gz"
  sha256 "9a8753ca73d8ecdab374e29e92649a32962f445e68485d010914f6c5911430dd"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6b68600a443ffe0486616240b8b7a37a288708c1df95cd272ea4168f7e8cd9c8"
  end

  depends_on "openjdk"

  def install
    rm_r("questdb.exe")
    libexec.install Dir["*"]
    (bin/"questdb").write_env_script libexec/"questdb.sh", Language::Java.overridable_java_home_env
    inreplace libexec/"questdb.sh", "/usr/local/var/questdb", var/"questdb"
  end

  def post_install
    # Make sure the var/questdb directory exists
    (var/"questdb").mkpath
  end

  service do
    run [opt_bin/"questdb", "start", "-d", var/"questdb", "-n", "-f"]
    keep_alive successful_exit: false
    error_log_path var/"log/questdb.log"
    log_path var/"log/questdb.log"
    working_dir var/"questdb"
  end

  test do
    # questdb.sh uses `ps | grep` to verify server is running, but output is truncated to COLUMNS
    # See https://github.com/Homebrew/homebrew-core/pull/133887#issuecomment-1679907729
    ENV.delete "COLUMNS" if OS.linux?

    mkdir_p testpath/"data"
    begin
      fork do
        exec bin/"questdb", "start", "-d", testpath/"data"
      end
      sleep 30
      output = shell_output("curl -Is localhost:9000/index.html")
      sleep 4
      assert_match "questDB", output
    ensure
      system bin/"questdb", "stop"
    end
  end
end
