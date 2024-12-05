class Trino < Formula
  include Language::Python::Shebang

  desc "Distributed SQL query engine for big data"
  homepage "https://trino.io"
  url "https://search.maven.org/remotecontent?filepath=io/trino/trino-server/466/trino-server-466.tar.gz", using: :nounzip
  sha256 "639072af271652b55673d430cbbd155669064d94be10b53a170a25c0b7a18e60"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=io/trino/trino-server/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)*)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd7f4a8e4d5d842e8fe8d5186a6e13b69dae54909eb8e91d9c3600f42117c3bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd7f4a8e4d5d842e8fe8d5186a6e13b69dae54909eb8e91d9c3600f42117c3bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dd7f4a8e4d5d842e8fe8d5186a6e13b69dae54909eb8e91d9c3600f42117c3bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "16efe4e9ff4440ab93ab3d68fdf8cf4fd62811ad27f19205ee79f845b69a2f3f"
    sha256 cellar: :any_skip_relocation, ventura:       "16efe4e9ff4440ab93ab3d68fdf8cf4fd62811ad27f19205ee79f845b69a2f3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bb20ed2491c758cad244ee837ba27de3091bc126286c0e902ab3749adf77b23"
  end

  depends_on "gnu-tar" => :build
  depends_on "openjdk"

  uses_from_macos "python"

  resource "trino-src" do
    url "https://mirror.ghproxy.com/https://github.com/trinodb/trino/archive/refs/tags/466.tar.gz", using: :nounzip
    sha256 "6828b1618d7dce034c7cd9f27613686e720362d0c43225b99fd8d6346c9cf2a8"
  end

  resource "trino-cli" do
    url "https://search.maven.org/remotecontent?filepath=io/trino/trino-cli/466/trino-cli-466-executable.jar"
    sha256 "2043732df1deeef76d0e145456205e4531847ed24820eb8581db79bc02be39a4"
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

    rewrite_shebang detected_python_shebang(use_python_from_path: true), libexec/"bin/launcher.py"
    (bin/"trino-server").write_env_script libexec/"bin/launcher", Language::Java.overridable_java_home_env

    resource("trino-cli").stage do
      libexec.install "trino-cli-#{version}-executable.jar"
      bin.write_jar_script libexec/"trino-cli-#{version}-executable.jar", "trino"
    end

    # Remove incompatible pre-built binaries
    launcher_dirs = libexec.glob("bin/{darwin,linux}-*")
    # Keep the linux-amd64 directory to make bottles identical
    launcher_dirs.reject! { |dir| dir.basename.to_s == "linux-amd64" } if build.bottle?
    launcher_dirs.reject! do |dir|
      dir.basename.to_s == "#{OS.kernel_name.downcase}-#{Hardware::CPU.intel? ? "amd64" : "arm64"}"
    end
    rm_r launcher_dirs
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
