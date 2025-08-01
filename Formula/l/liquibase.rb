class Liquibase < Formula
  desc "Library for database change tracking"
  homepage "https://www.liquibase.org/"
  url "https://mirror.ghproxy.com/https://github.com/liquibase/liquibase/releases/download/v4.33.0/liquibase-4.33.0.tar.gz"
  sha256 "689acfcdc97bad0d4c150d1efab9c851e251b398cb3d6326f75e8aafe40ed578"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "222519225b5374762241360ed0c6720d11f31a6b996c2df9268fe321bf7917aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "222519225b5374762241360ed0c6720d11f31a6b996c2df9268fe321bf7917aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "222519225b5374762241360ed0c6720d11f31a6b996c2df9268fe321bf7917aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "7181fa982b8c07cdc61e486770ea6f0f12b642eb4a85c9f01bf9e4a8bf764e0e"
    sha256 cellar: :any_skip_relocation, ventura:       "7181fa982b8c07cdc61e486770ea6f0f12b642eb4a85c9f01bf9e4a8bf764e0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "222519225b5374762241360ed0c6720d11f31a6b996c2df9268fe321bf7917aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "222519225b5374762241360ed0c6720d11f31a6b996c2df9268fe321bf7917aa"
  end

  depends_on "openjdk"

  def install
    rm(Dir["*.bat"])

    chmod 0755, "liquibase"
    libexec.install Dir["*"]
    bash_completion.install libexec/"lib/liquibase_autocomplete.sh" => "liquibase"
    zsh_completion.install libexec/"lib/liquibase_autocomplete.zsh" => "_liquibase"
    (bin/"liquibase").write_env_script libexec/"liquibase", Language::Java.overridable_java_home_env
  end

  def caveats
    <<~EOS
      You should set the environment variable LIQUIBASE_HOME to
        #{opt_libexec}
    EOS
  end

  test do
    system bin/"liquibase", "--version"
  end
end
