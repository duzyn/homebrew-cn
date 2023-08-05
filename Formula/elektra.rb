class Elektra < Formula
  desc "Framework to access config settings in a global key database"
  homepage "https://www.libelektra.org/home"
  url "https://www.libelektra.org/ftp/elektra/releases/elektra-0.11.0.tar.gz"
  sha256 "4e1f7c986010555a1d30ef2d23c0636373e993bab88e5ec238cac18a469b5cc2"
  license "BSD-3-Clause"
  head "https://github.com/ElektraInitiative/libelektra.git", branch: "master"

  livecheck do
    url "https://www.libelektra.org/ftp/elektra/releases/"
    regex(/href=.*?elektra[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "225bf8018ed6d4ab4b17e06b0fd54734aa8549aa9014fb45fd3c169a1baa95ac"
    sha256 arm64_monterey: "b2adcbd5ee3af2902697b7a7ff66ff03c44f0606e4b3713f3040f5b65c529d6e"
    sha256 arm64_big_sur:  "030d9616b72dcba09a838efff2d3ab1bf4f250d94e404b44232822f27ecf40f8"
    sha256 ventura:        "572831f83143c1f019fd2f3a964778f3614f06a9bd47a94cf533fb53b07d0d6f"
    sha256 monterey:       "a0afa6b581c6e4224136a484fdce54340cfc33b7c59faba3c713f4418a9e95ba"
    sha256 big_sur:        "840c731a3c0afc0b417a8886f24ef3a9bb20c5ae27571a3bb9df382c29358faf"
    sha256 x86_64_linux:   "19c2348d85346bf54e1858e38c256a0c3fc5b53663118dd4a6080f37ab4610f3"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-DBINDINGS=cpp", "-DTOOLS=kdb;",
                            "-DPLUGINS=NODEP;-tracer", *std_cmake_args
      system "make", "install"
    end

    bash_completion.install "scripts/completion/kdb-bash-completion" => "kdb"
    fish_completion.install "scripts/completion/kdb.fish"
    zsh_completion.install "scripts/completion/kdb_zsh_completion" => "_kdb"
  end

  test do
    output = shell_output("#{bin}/kdb get system:/elektra/version/infos/licence")
    assert_match "BSD", output
    shell_output("#{bin}/kdb plugin-list").split.each do |plugin|
      system "#{bin}/kdb", "plugin-check", plugin
    end
  end
end
