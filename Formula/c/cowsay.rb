class Cowsay < Formula
  desc "Apjanke's fork of the classic cowsay project"
  homepage "https://cowsay.diamonds"
  url "https://mirror.ghproxy.com/https://github.com/cowsay-org/cowsay/archive/refs/tags/v3.8.3.tar.gz"
  sha256 "3bcb1f644a85792bc2ee8601971f16f8f1e7ca0013d6062cf35b4fd6d8fa29ea"
  license "GPL-3.0-only"
  head "https://github.com/cowsay-org/cowsay.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "549d525741c960a333379336876748b9bd139df0a2dcf6d51331ca48c5fb1242"
  end

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    output = shell_output("#{bin}/cowsay moo")
    assert_match "moo", output  # bubble
    assert_match "^__^", output # cow
  end
end
