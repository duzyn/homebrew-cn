class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "https://wxmaxima-developers.github.io/wxmaxima/"
  url "https://github.com/wxMaxima-developers/wxmaxima/archive/Version-22.11.1.tar.gz"
  sha256 "54c7f2959fe3f0eac0db9083462d81f9058cc488bd0a86feb97683cfbc131f13"
  license "GPL-2.0-or-later"
  head "https://github.com/wxMaxima-developers/wxmaxima.git", branch: "main"

  bottle do
    sha256 arm64_ventura:  "dbb7ac08d3134a56fb5cbef97c57c74b41906351608319e7914b039d8d814cf6"
    sha256 arm64_monterey: "1dcda0c8102846676817d9e7029a86b71ce432ce8b0c8396e88db81dfcc40423"
    sha256 arm64_big_sur:  "34b1f015bd3c70af65beed3ea9afef59dcea05f641b43ccf4f0c9028d4956c25"
    sha256 ventura:        "2a3b4315d6af5d2522ec32f1cd74734754398cbb933ef3fc29e4b543fe043239"
    sha256 monterey:       "f5c909f5019eb059bf1840ece98230c0e08f78865f129010b9b48d7c230a6ea3"
    sha256 big_sur:        "c974e8b7ffa9199c461f48eaa41715d381841b67225f1d03f5a2d65505582daf"
    sha256 catalina:       "d5135b75f2644e282e85966d2259ba9f798da813e1de3f19039ec42cbeba092c"
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
