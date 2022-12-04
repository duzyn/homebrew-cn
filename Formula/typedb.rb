class Typedb < Formula
  desc "Distributed hyper-relational database for knowledge engineering"
  homepage "https://vaticle.com/"
  url "https://ghproxy.com/github.com/vaticle/typedb/releases/download/2.14.2/typedb-all-mac-2.14.2.zip"
  sha256 "0db71995048fb8de820618f32db973e88ff65e648c169991a6925b218fdb395d"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "02070db158eb0bca13c401f18c1bb05a7a0d801f8b274e99187087b66c83e8d7"
  end

  depends_on "openjdk@11"

  def install
    libexec.install Dir["*"]
    bin.install libexec/"typedb"
    bin.env_script_all_files(libexec, Language::Java.java_home_env("11"))
  end

  test do
    assert_match "A STRONGLY-TYPED DATABASE", shell_output("#{bin}/typedb server --help")
  end
end
