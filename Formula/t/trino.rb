class Trino < Formula
  include Language::Python::Shebang

  desc "Distributed SQL query engine for big data"
  homepage "https://trino.io"
  url "https://search.maven.org/remotecontent?filepath=io/trino/trino-server/453/trino-server-453.tar.gz", using: :nounzip
  sha256 "ca05205a7079cb1d01d580b08bae66c2b33ef65de3491e2ed8ba1e58d1876005"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=io/trino/trino-server/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)*)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4575a459859b08e8a07a0715f42a3782c46957117bddabe40be3b2287f65a3e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4575a459859b08e8a07a0715f42a3782c46957117bddabe40be3b2287f65a3e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4575a459859b08e8a07a0715f42a3782c46957117bddabe40be3b2287f65a3e4"
    sha256 cellar: :any_skip_relocation, sonoma:         "4575a459859b08e8a07a0715f42a3782c46957117bddabe40be3b2287f65a3e4"
    sha256 cellar: :any_skip_relocation, ventura:        "4575a459859b08e8a07a0715f42a3782c46957117bddabe40be3b2287f65a3e4"
    sha256 cellar: :any_skip_relocation, monterey:       "4575a459859b08e8a07a0715f42a3782c46957117bddabe40be3b2287f65a3e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a37148e122e7b061d77877d35298bcbb5b3c9a49f94c720bc33eca761fbe9e0e"
  end

  depends_on "gnu-tar" => :build
  depends_on "openjdk"
  depends_on "python@3.12"

  resource "trino-src" do
    url "https://mirror.ghproxy.com/https://github.com/trinodb/trino/archive/refs/tags/453.tar.gz", using: :nounzip
    sha256 "e2566b8dc49a89e62e7caad49537c0ddae7a5e47e691d2af536b068889c45ac7"
  end

  resource "trino-cli" do
    url "https://search.maven.org/remotecontent?filepath=io/trino/trino-cli/453/trino-cli-453-executable.jar"
    sha256 "3b65b29afe15ef8745bf81658fd1a136fdc95945868c8c13de403a98d18df223"
  end

  def install
    odie "trino-src resource needs to be updated" if version != resource("trino-src").version
    odie "trino-cli resource needs to be updated" if version != resource("trino-cli").version

    # Manually extract tarball to avoid losing hardlinks which increases bottle
    # size from MBs to GBs. Remove once Homebrew is able to preserve hardlinks.
    # Ref: https://github.com/Homebrew/brew/pull/13154
    libexec.mkpath
    system "tar", "-C", libexec.to_s, "--strip-components", "1", "-xzf", "trino-server-#{version}.tar.gz"

    # Manually untar, since macOS-bundled tar produces the error:
    #   trino-363/plugin/trino-hive/src/test/resources/<truncated>.snappy.orc.crc: Failed to restore metadata
    # Remove when https://github.com/trinodb/trino/issues/8877 is fixed
    resource("trino-src").stage do |r|
      ENV.prepend_path "PATH", Formula["gnu-tar"].opt_libexec/"gnubin"
      system "tar", "-xzf", "trino-#{r.version}.tar.gz"
      (libexec/"etc").install Dir["trino-#{r.version}/core/docker/default/etc/*"]
      inreplace libexec/"etc/node.properties", "docker", tap.user.downcase
      inreplace libexec/"etc/node.properties", "/data/trino", var/"trino/data"
      inreplace libexec/"etc/jvm.config", %r{^-agentpath:/usr/lib/trino/bin/libjvmkill.so$\n}, ""
    end

    rewrite_shebang detected_python_shebang, libexec/"bin/launcher.py"
    (bin/"trino-server").write_env_script libexec/"bin/launcher", Language::Java.overridable_java_home_env

    resource("trino-cli").stage do
      libexec.install "trino-cli-#{version}-executable.jar"
      bin.write_jar_script libexec/"trino-cli-#{version}-executable.jar", "trino"
    end

    # Remove incompatible pre-built binaries
    libprocname_dirs = libexec.glob("bin/procname/*")
    # Keep the Linux-x86_64 directory to make bottles identical
    libprocname_dirs.reject! { |dir| dir.basename.to_s == "Linux-x86_64" } if build.bottle?
    libprocname_dirs.reject! { |dir| dir.basename.to_s == "#{OS.kernel_name}-#{Hardware::CPU.arch}" }
    rm_r libprocname_dirs
  end

  def post_install
    (var/"trino/data").mkpath
  end

  service do
    run [opt_bin/"trino-server", "run"]
    working_dir opt_libexec
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/trino --version")
    # A more complete test existed before but we removed it because it crashes macOS
    # https://github.com/Homebrew/homebrew-core/pull/153348
    # You can add it back when the following issue is fixed:
    # https://github.com/trinodb/trino/issues/18983#issuecomment-1794206475
    # https://bugs.openjdk.org/browse/CODETOOLS-7903448
  end
end
