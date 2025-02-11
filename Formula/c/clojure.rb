class Clojure < Formula
  desc "Dynamic, general-purpose programming language"
  homepage "https://clojure.org"
  url "https://mirror.ghproxy.com/https://github.com/clojure/brew-install/releases/download/1.12.0.1517/clojure-tools-1.12.0.1517.tar.gz"
  mirror "https://download.clojure.org/install/clojure-tools-1.12.0.1517.tar.gz"
  sha256 "38694e876c7a5360c16f4b7d2c3993b723201c58226d0938cd021765e33a51ef"
  license "EPL-1.0"
  version_scheme 1

  livecheck do
    url "https://mirror.ghproxy.com/https://raw.githubusercontent.com/clojure/homebrew-tools/master/Formula/clojure.rb"
    regex(/url ".*?clojure-tools-v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1c9bfe93e1d2720d461c066860140f62ff2e1f2fd410832c37161b51e16f2529"
  end

  depends_on "openjdk"
  depends_on "rlwrap"

  uses_from_macos "ruby" => :build

  def install
    system "./install.sh", prefix
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env
  end

  test do
    ENV["TERM"] = "xterm"
    system("#{bin}/clj", "-e", "nil")
    %w[clojure clj].each do |clj|
      assert_equal "2", shell_output("#{bin}/#{clj} -e \"(+ 1 1)\"").strip
    end
  end
end
