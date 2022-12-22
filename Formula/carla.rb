class Carla < Formula
  desc "Audio plugin host supporting LADSPA, LV2, VST2/3, SF2 and more"
  homepage "https://kxstudio.linuxaudio.org/Applications:Carla"
  url "https://github.com/falkTX/Carla/archive/v2.5.2.tar.gz"
  sha256 "e93c5d169538c991e1598c7de34a80f2e53af3cd063bb672fa020ba8e7dae140"
  license "GPL-2.0-or-later"
  head "https://github.com/falkTX/Carla.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "c7697e9831c2368b1231fdfd7d3488782644a5d20b0b2bef050828e62b009ee7"
    sha256 cellar: :any,                 arm64_monterey: "a3054ec4823bd72dcbee11bb683d3d65662136b31900050d655ab314bf6a0aab"
    sha256 cellar: :any,                 arm64_big_sur:  "f14c740272442ce6f573995c253a38cace30a88918a6e4ce4eb5c065c5f60281"
    sha256 cellar: :any,                 ventura:        "9f7c9e2370458aa307de52175d51eadd6eedd8a03da2b22750320592acffa2dd"
    sha256 cellar: :any,                 monterey:       "1d3fc9b4f2fc1d46800cc522ac0a826eede707e86cd522e9d244ef9665e8e84b"
    sha256 cellar: :any,                 big_sur:        "81d2ec0a2a986aaf286abf4c169df0ceec42435ca0376fab0d268155a2424209"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "637095b6218896ea500a6318420faea52aa087d552a273dfbf2b5454428fd55a"
  end

  depends_on "pkg-config" => :build
  depends_on "fluid-synth"
  depends_on "liblo"
  depends_on "libmagic"
  depends_on "pyqt@5"
  depends_on "python@3.11"

  fails_with gcc: "5"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"

    inreplace bin/"carla", "PYTHON=$(which python3 2>/dev/null)",
                           "PYTHON=#{Formula["python@3.11"].opt_bin}/python3.11"
  end

  test do
    system bin/"carla", "--version"
    system lib/"carla/carla-discovery-native", "internal", ":all"
  end
end
