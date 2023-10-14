class Jenkins < Formula
  desc "Extendable open source continuous integration server"
  homepage "https://www.jenkins.io/"
  url "https://get.jenkins.io/war/2.427/jenkins.war"
  sha256 "0fc5c7b9956221ed7deac1ce7c2ac3f86d0059fac6ceabfec11718550fb701d2"
  license "MIT"

  livecheck do
    url "https://www.jenkins.io/download/"
    regex(%r{href=.*?/war/v?(\d+(?:\.\d+)+)/jenkins\.war}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e860cb250e0a67b33373d616d3d0f5ebe7965a060e7b8e59326512f20a24d3cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e860cb250e0a67b33373d616d3d0f5ebe7965a060e7b8e59326512f20a24d3cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e860cb250e0a67b33373d616d3d0f5ebe7965a060e7b8e59326512f20a24d3cd"
    sha256 cellar: :any_skip_relocation, sonoma:         "e860cb250e0a67b33373d616d3d0f5ebe7965a060e7b8e59326512f20a24d3cd"
    sha256 cellar: :any_skip_relocation, ventura:        "e860cb250e0a67b33373d616d3d0f5ebe7965a060e7b8e59326512f20a24d3cd"
    sha256 cellar: :any_skip_relocation, monterey:       "e860cb250e0a67b33373d616d3d0f5ebe7965a060e7b8e59326512f20a24d3cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "febc3d6a0d034445dfd5abe9abd8926863cd99ad6cf4d03d4041b711e523e3f7"
  end

  head do
    url "https://github.com/jenkinsci/jenkins.git", branch: "master"
    depends_on "maven" => :build
  end

  depends_on "openjdk"

  def install
    if build.head?
      system "mvn", "clean", "install", "-pl", "war", "-am", "-DskipTests"
    else
      system "#{Formula["openjdk"].opt_bin}/jar", "xvf", "jenkins.war"
    end
    libexec.install Dir["**/jenkins.war", "**/cli-#{version}.jar"]
    bin.write_jar_script libexec/"jenkins.war", "jenkins"
    bin.write_jar_script libexec/"cli-#{version}.jar", "jenkins-cli"

    (var/"log/jenkins").mkpath
  end

  def caveats
    <<~EOS
      Note: When using launchctl the port will be 8080.
    EOS
  end

  service do
    run [opt_bin/"jenkins", "--httpListenAddress=127.0.0.1", "--httpPort=8080"]
    keep_alive true
    log_path var/"log/jenkins/output.log"
    error_log_path var/"log/jenkins/error.log"
  end

  test do
    ENV["JENKINS_HOME"] = testpath
    ENV.prepend "_JAVA_OPTIONS", "-Djava.io.tmpdir=#{testpath}"

    port = free_port
    fork do
      exec "#{bin}/jenkins --httpPort=#{port}"
    end
    sleep 60

    output = shell_output("curl localhost:#{port}/")
    assert_match(/Welcome to Jenkins!|Unlock Jenkins|Authentication required/, output)
  end
end