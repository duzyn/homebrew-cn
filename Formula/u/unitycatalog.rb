class Unitycatalog < Formula
  desc "Open, Multi-modal Catalog for Data & AI"
  homepage "https://unitycatalog.io/"
  url "https://mirror.ghproxy.com/https://github.com/unitycatalog/unitycatalog/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "fae708a22f1e38e19f754aca22925d66016a7efeaab680ce87c27496c75078d1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19b009e2d141df4fca169ea68b5c1d01938e9f65e7b8433472e72a2aec9abd80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19b009e2d141df4fca169ea68b5c1d01938e9f65e7b8433472e72a2aec9abd80"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "19b009e2d141df4fca169ea68b5c1d01938e9f65e7b8433472e72a2aec9abd80"
    sha256 cellar: :any_skip_relocation, sonoma:        "19b009e2d141df4fca169ea68b5c1d01938e9f65e7b8433472e72a2aec9abd80"
    sha256 cellar: :any_skip_relocation, ventura:       "19b009e2d141df4fca169ea68b5c1d01938e9f65e7b8433472e72a2aec9abd80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb4fb9ab2d49654bf9a56b439a6ce891283e6360662251f77a6ff7b67c4d57a9"
  end

  depends_on "sbt" => :build
  depends_on "openjdk@21"

  def install
    system "sbt", "createTarball"

    mkdir "build" do
      system "tar", "xzf", "../target/unitycatalog-#{version}.tar.gz", "-C", "."

      inreplace "jars/classpath" do |s|
        s.gsub! %r{[^:]+/([^/]+\.jar)}, "#{libexec}/jars/\\1"
      end

      prefix.install "bin"
      libexec.install "jars"
      pkgetc.install "etc"
    end

    env = Language::Java.overridable_java_home_env("21")
    env["PATH"] = "${JAVA_HOME}/bin:${PATH}" if OS.linux?
    bin.env_script_all_files libexec/"bin", env
  end

  service do
    run opt_bin/"start-uc-server"
    working_dir etc/"unitycatalog"
  end

  test do
    port = free_port
    spawn bin/"start-uc-server", "--port", port.to_s
    sleep 20

    output = shell_output("#{bin}/uc catalog list --server http://localhost:#{port}")
    assert_match "[]", output
  end
end
