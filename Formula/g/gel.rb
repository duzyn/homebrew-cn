class Gel < Formula
  desc "Modern gem manager"
  homepage "https://gel.dev"
  url "https://mirror.ghproxy.com/https://github.com/gel-rb/gel/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "fe7c4bd67a2ea857b85b754f5b4d336e26640eda7199bc99b9a1570043362551"
  license "MIT"
  revision 1
  head "https://github.com/gel-rb/gel.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "898572d813d48ead8bc112c19eab9964c5ba560062fe57e40f138840a35ee5da"
  end

  depends_on "ronn" => :build

  uses_from_macos "ruby"

  def install
    system "rake", "man"
    bin.install "exe/gel"
    prefix.install "lib"
    man1.install Pathname.glob("man/man1/*.1")
  end

  test do
    (testpath/"Gemfile").write <<~EOS
      source "https://rubygems.org"
      gem "gel"
    EOS
    system bin/"gel", "install"
  end
end
