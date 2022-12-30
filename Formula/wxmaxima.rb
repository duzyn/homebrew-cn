class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "https://wxmaxima-developers.github.io/wxmaxima/"
  url "https://github.com/wxMaxima-developers/wxmaxima/archive/Version-22.12.0.tar.gz"
  sha256 "fc479e1c6c14f5fd49d103c86e4a9c9d904953076413a9137ab29874620c4fa0"
  license "GPL-2.0-or-later"
  head "https://github.com/wxMaxima-developers/wxmaxima.git", branch: "main"

  bottle do
    sha256 arm64_ventura:  "3fd8f0a32926ea41a6ff908e479e205d5cba6788cbd062a2b211b965a550bceb"
    sha256 arm64_monterey: "00bc43efc9e354fdd196814ddaa9a11b7c969a8e603d7295117c64c4fc5f6f1d"
    sha256 arm64_big_sur:  "12be2dc241d92964d199cb82b47bc76e5ab8ae151ccb96fdc35b127dcfff6f5e"
    sha256 ventura:        "0d6215787b99ea593f3bee36da37bb40f532fa6f7841396dbc7e64c40e77b9e7"
    sha256 monterey:       "7aac965dbcacd466bafaed8fa4b1f28f484e55e3b3c9c9169a0931e5671272d8"
    sha256 big_sur:        "8f96c8e5f788d48ddcc3b55c45b5d3715311e82ec404d0dae4f2ce196bc4bd04"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "ninja" => :build
  depends_on "maxima"
  depends_on "wxwidgets"

  def install
    system "cmake", "-S", ".", "-B", "build-wxm", "-G", "Ninja", *std_cmake_args
    system "cmake", "--build", "build-wxm"
    system "cmake", "--install", "build-wxm"
    bash_completion.install "data/wxmaxima"

    return unless OS.mac?

    prefix.install "build-wxm/src/wxMaxima.app"
    bin.write_exec_script prefix/"wxMaxima.app/Contents/MacOS/wxmaxima"
  end

  def caveats
    <<~EOS
      When you start wxMaxima the first time, set the path to Maxima
      (e.g. #{HOMEBREW_PREFIX}/bin/maxima) in the Preferences.

      Enable gnuplot functionality by setting the following variables
      in ~/.maxima/maxima-init.mac:
        gnuplot_command:"#{HOMEBREW_PREFIX}/bin/gnuplot"$
        draw_command:"#{HOMEBREW_PREFIX}/bin/gnuplot"$
    EOS
  end

  test do
    # Error: Unable to initialize GTK+, is DISPLAY set properly
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match "algebra", shell_output("#{bin}/wxmaxima --help 2>&1")
  end
end
