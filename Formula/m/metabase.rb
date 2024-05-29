class Metabase < Formula
  desc "Business intelligence report server"
  homepage "https://www.metabase.com/"
  url "https://downloads.metabase.com/v0.49.12/metabase.jar"
  sha256 "f931d0e22ef030effbe8c36376f0e8aacb45717927679fc5f364cd5e7d3b8274"
  license "AGPL-3.0-only"

  livecheck do
    url "https://www.metabase.com/start/oss/jar.html"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/metabase\.jar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ae7f07b88a06cf7504c98efb5a69fd5a1b528aedf5357a581b833fa03378ddb6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae7f07b88a06cf7504c98efb5a69fd5a1b528aedf5357a581b833fa03378ddb6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae7f07b88a06cf7504c98efb5a69fd5a1b528aedf5357a581b833fa03378ddb6"
    sha256 cellar: :any_skip_relocation, sonoma:         "ae7f07b88a06cf7504c98efb5a69fd5a1b528aedf5357a581b833fa03378ddb6"
    sha256 cellar: :any_skip_relocation, ventura:        "ae7f07b88a06cf7504c98efb5a69fd5a1b528aedf5357a581b833fa03378ddb6"
    sha256 cellar: :any_skip_relocation, monterey:       "ae7f07b88a06cf7504c98efb5a69fd5a1b528aedf5357a581b833fa03378ddb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08f5ea886ba9b67afadd8f2399fdaa434ec4f5882dd400e27089516aa29ffd2a"
  end

  head do
    url "https://github.com/metabase/metabase.git", branch: "master"

    depends_on "leiningen" => :build
    depends_on "node" => :build
    depends_on "yarn" => :build
  end

  depends_on "openjdk"

  def install
    if build.head?
      system "./bin/build"
      libexec.install "target/uberjar/metabase.jar"
    else
      libexec.install "metabase.jar"
    end

    bin.write_jar_script libexec/"metabase.jar", "metabase"
  end

  service do
    run opt_bin/"metabase"
    keep_alive true
    require_root true
    working_dir var/"metabase"
    log_path var/"metabase/server.log"
    error_log_path "/dev/null"
  end

  test do
    system bin/"metabase", "migrate", "up"
  end
end
