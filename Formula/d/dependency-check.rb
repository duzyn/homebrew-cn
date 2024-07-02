class DependencyCheck < Formula
  desc "OWASP dependency-check"
  homepage "https://owasp.org/www-project-dependency-check/"
  url "https://mirror.ghproxy.com/https://github.com/jeremylong/DependencyCheck/releases/download/v10.0.0/dependency-check-10.0.0-release.zip"
  sha256 "d93c6aa0146feb7c10c22e30f8218da6c8b3bbc33d4ef86d8843d19aae59754b"
  license "Apache-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?dependency-check[._-]v?(\d+(?:\.\d+)+)-release\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eac49e5409f44caef9e6bdb210f3d54692f12f988455517e2b49ed282eb65a51"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eac49e5409f44caef9e6bdb210f3d54692f12f988455517e2b49ed282eb65a51"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eac49e5409f44caef9e6bdb210f3d54692f12f988455517e2b49ed282eb65a51"
    sha256 cellar: :any_skip_relocation, sonoma:         "eac49e5409f44caef9e6bdb210f3d54692f12f988455517e2b49ed282eb65a51"
    sha256 cellar: :any_skip_relocation, ventura:        "eac49e5409f44caef9e6bdb210f3d54692f12f988455517e2b49ed282eb65a51"
    sha256 cellar: :any_skip_relocation, monterey:       "eac49e5409f44caef9e6bdb210f3d54692f12f988455517e2b49ed282eb65a51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "060b99f1b4f7b99e2fe0f4d932023cad1e67493533df85cb96f74afa36d734e7"
  end

  depends_on "openjdk"

  def install
    rm_f Dir["bin/*.bat"]

    chmod 0755, "bin/dependency-check.sh"
    libexec.install Dir["*"]

    (bin/"dependency-check").write_env_script libexec/"bin/dependency-check.sh",
      JAVA_HOME: Formula["openjdk"].opt_prefix

    (var/"dependencycheck").mkpath
    libexec.install_symlink var/"dependencycheck" => "data"

    (etc/"dependencycheck").mkpath
    jar = "dependency-check-core-#{version}.jar"
    corejar = libexec/"lib/#{jar}"
    system "unzip", "-o", corejar, "dependencycheck.properties", "-d", libexec/"etc"
    (etc/"dependencycheck").install_symlink libexec/"etc/dependencycheck.properties"
  end

  test do
    # wait a random amount of time as multiple tests are being on different OS
    # the sleep 1 seconds to 30 seconds assists with the NVD Rate Limiting issues
    sleep(rand(1..30))
    output = shell_output("#{bin}/dependency-check --version").strip
    assert_match "Dependency-Check Core version #{version}", output

    (testpath/"temp-props.properties").write <<~EOS
      cve.startyear=2017
      analyzer.assembly.enabled=false
      analyzer.dependencymerging.enabled=false
      analyzer.dependencybundling.enabled=false
    EOS
    system bin/"dependency-check", "-P", "temp-props.properties", "-f", "XML",
              "--project", "dc", "-s", libexec, "-d", testpath, "-o", testpath,
              "--nvdDatafeed", "https://jeremylong.github.io/DependencyCheck/hb_nvd/",
              "--disableKnownExploited"
    assert_predicate testpath/"dependency-check-report.xml", :exist?
  end
end
