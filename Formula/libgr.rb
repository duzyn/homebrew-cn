class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/v0.71.3.tar.gz"
  sha256 "b9bf0bdeb8ce896d7cc01e79468fefdadecc09cab94183920783921fcad65eda"
  license "MIT"

  bottle do
    sha256 arm64_ventura:  "557b753b7da49304746ed7137f4646aebd9914610315aaaaa5a9a2897796f4dd"
    sha256 arm64_monterey: "8f237d3af89308a8a85605abd3883146cb597c02b4cc9ef26d401df8de022cf2"
    sha256 arm64_big_sur:  "a59efcb823e2fe814834f3f812644605c4569a206d0d8c865663d570d36cea14"
    sha256 ventura:        "9f8c6f78c1d87e5249eecc15b587cf5ab3c56729782ef9de1d51ea7b3e1d6308"
    sha256 monterey:       "f65769366b6689eae19fd4158995b7d44113673ef7bf34cc43f4d2bc432cb38c"
    sha256 big_sur:        "9d921cbd071652545128260ced1f529ba972c5416dc3baa0f2e9296e213f8d8c"
  end

  depends_on "cmake" => :build
  depends_on "cairo"
  depends_on "glfw"
  depends_on "libtiff"
  depends_on "qhull"
  depends_on "qt"
  depends_on "zeromq"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <gr.h>

      int main(void) {
          gr_opengks();
          gr_openws(1, "test.png", 140);
          gr_activatews(1);
          double x[] = {0, 0.2, 0.4, 0.6, 0.8, 1.0};
          double y[] = {0.3, 0.5, 0.4, 0.2, 0.6, 0.7};
          gr_polyline(6, x, y);
          gr_axes(gr_tick(0, 1), gr_tick(0, 1), 0, 0, 1, 1, -0.01);
          gr_updatews();
          gr_emergencyclosegks();
          return 0;
      }
    EOS

    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lGR"
    system "./test"

    assert_predicate testpath/"test.png", :exist?
  end
end
