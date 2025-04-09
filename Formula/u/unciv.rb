class Unciv < Formula
  desc "Open-source Android/Desktop remake of Civ V"
  homepage "https://github.com/yairm210/Unciv"
  url "https://mirror.ghproxy.com/https://github.com/yairm210/Unciv/releases/download/4.16.2/Unciv.jar"
  sha256 "727522ca1f9f08ae422a0f889394d00fec1e3041ea8ec04487f6cea4e2a83a8c"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:[._-]?patch\d*)?)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "efc1170bdb8b46bc55aacbfaedaacd39292b883327fcf22905f474ffe58c4e95"
  end

  depends_on "openjdk"

  def install
    libexec.install "Unciv.jar"
    bin.write_jar_script libexec/"Unciv.jar", "unciv"
  end

  test do
    # Unciv is a GUI application, so there is no cli functionality to test
    assert_match version.to_str, shell_output("#{bin}/unciv --version")
  end
end
