class Liquibase < Formula
  desc "Library for database change tracking"
  homepage "https://www.liquibase.org/"
  url "https://ghproxy.com/github.com/liquibase/liquibase/releases/download/v4.18.0/liquibase-4.18.0.tar.gz"
  sha256 "6113f652d06a71556d6ed4a8bb371ab2d843010cb0365379e83df8b4564a6a76"
  license "Apache-2.0"

  livecheck do
    url "https://www.liquibase.org/download"
    regex(/href=.*?liquibase[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "88e02efe171dd0f2624e61d94b868f77dd68de87d1203eea752c968ed1c8da93"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88e02efe171dd0f2624e61d94b868f77dd68de87d1203eea752c968ed1c8da93"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "88e02efe171dd0f2624e61d94b868f77dd68de87d1203eea752c968ed1c8da93"
    sha256 cellar: :any_skip_relocation, ventura:        "d1aa2e72440de49d48fa98af6ff54ba4333ff6641d54320d640c7d6aae86e5b1"
    sha256 cellar: :any_skip_relocation, monterey:       "d1aa2e72440de49d48fa98af6ff54ba4333ff6641d54320d640c7d6aae86e5b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "d1aa2e72440de49d48fa98af6ff54ba4333ff6641d54320d640c7d6aae86e5b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88e02efe171dd0f2624e61d94b868f77dd68de87d1203eea752c968ed1c8da93"
  end

  depends_on "openjdk"

  def install
    rm_f Dir["*.bat"]
    chmod 0755, "liquibase"
    prefix.install_metafiles
    libexec.install Dir["*"]
    (bin/"liquibase").write_env_script libexec/"liquibase", Language::Java.overridable_java_home_env
    (libexec/"lib").install_symlink Dir["#{libexec}/sdk/lib-sdk/slf4j*"]
  end

  def caveats
    <<~EOS
      You should set the environment variable LIQUIBASE_HOME to
        #{opt_libexec}
    EOS
  end

  test do
    system "#{bin}/liquibase", "--version"
  end
end
