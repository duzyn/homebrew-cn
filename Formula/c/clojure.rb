class Clojure < Formula
  desc "Dynamic, general-purpose programming language"
  homepage "https://clojure.org"
  url "https://mirror.ghproxy.com/https://github.com/clojure/brew-install/releases/download/1.12.1.1538/clojure-tools-1.12.1.1538.tar.gz"
  mirror "https://download.clojure.org/install/clojure-tools-1.12.1.1538.tar.gz"
  sha256 "1c878646fda838b39a5b53574bc96f3d22a2a8f474f34d84540158287aaed63e"
  license "EPL-1.0"
  version_scheme 1

  livecheck do
    url "https://mirror.ghproxy.com/https://raw.githubusercontent.com/clojure/homebrew-tools/master/Formula/clojure.rb"
    regex(/url ".*?clojure-tools-v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "47ddb5df191a3b9879f7a110f996749327798af55138bd13a750ed173d96ecf4"
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
