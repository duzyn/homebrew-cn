class Groovysdk < Formula
  desc "SDK for Groovy: a Java-based scripting language"
  homepage "https://www.groovy-lang.org/"
  url "https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-sdk-4.0.7.zip"
  sha256 "9e17a5e3da1418543740d98501bf17a2df05477369edf80c510e332f68db89e0"
  license "Apache-2.0"

  livecheck do
    url "https://groovy.apache.org/download.html"
    regex(/href=.*?apache-groovy-sdk[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7bbdd9241ccd74b51979a574d60fb8b43e45eb100201bd6cc10378a883e53457"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7bbdd9241ccd74b51979a574d60fb8b43e45eb100201bd6cc10378a883e53457"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7bbdd9241ccd74b51979a574d60fb8b43e45eb100201bd6cc10378a883e53457"
    sha256 cellar: :any_skip_relocation, ventura:        "f75cd8efecf78d4dd451685b032b5b808d7a12eb4fd735b107718771dff45fa9"
    sha256 cellar: :any_skip_relocation, monterey:       "f75cd8efecf78d4dd451685b032b5b808d7a12eb4fd735b107718771dff45fa9"
    sha256 cellar: :any_skip_relocation, big_sur:        "f75cd8efecf78d4dd451685b032b5b808d7a12eb4fd735b107718771dff45fa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bbdd9241ccd74b51979a574d60fb8b43e45eb100201bd6cc10378a883e53457"
  end

  depends_on "openjdk"

  conflicts_with "groovy", because: "both install the same binaries"

  def install
    # We don't need Windows' files.
    rm_f Dir["bin/*.bat"]

    prefix.install_metafiles
    bin.install Dir["bin/*"]
    libexec.install "conf", "lib", "src", "doc"
    bin.env_script_all_files libexec/"bin",
                             GROOVY_HOME: libexec,
                             JAVA_HOME:   "${JAVA_HOME:-#{Formula["openjdk"].opt_prefix}}"
  end

  test do
    system "#{bin}/grape", "install", "org.activiti", "activiti-engine", "5.16.4"
  end
end
