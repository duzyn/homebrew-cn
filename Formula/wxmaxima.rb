class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "https://wxmaxima-developers.github.io/wxmaxima/"
  url "https://github.com/wxMaxima-developers/wxmaxima/archive/Version-22.11.0.tar.gz"
  sha256 "df581dfe128f22583fc117ae7bca9f0f1bd69602ee322bb7f0204fd305239249"
  license "GPL-2.0-or-later"
  head "https://github.com/wxMaxima-developers/wxmaxima.git", branch: "main"

  bottle do
    sha256 arm64_ventura:  "87f505ba07495ce4fc733243a78aca7a081b82e25933133aba47e597a3dad9e5"
    sha256 arm64_monterey: "5b22a4ed8addbd1e660208bd70894e26ded7ff336a531a0c961d93049fae2655"
    sha256 arm64_big_sur:  "f6251f70990417f4551bcc003abace1e4c18e4a773a5c6b5642dc7b86cc76687"
    sha256 ventura:        "99effd3709702a22eb70a2efc2d7e764726ed6fa105d5185b438a8a770740fa0"
    sha256 monterey:       "05abc6ef488f68873b5c060ac458f2a810b8301ce77ca4a4381fe781f88d8611"
    sha256 big_sur:        "446323dbb13b405ee0048255a1809937f48612689ac9d997cf77f141e910e245"
    sha256 catalina:       "d1010a0dc08c6adae2b676828c84508d06e60499645a01a033c0523fea8fb38b"
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
