class GstRtspServer < Formula
  desc "RTSP server library based on GStreamer"
  homepage "https://gstreamer.freedesktop.org/modules/gst-rtsp-server.html"
  url "https://gstreamer.freedesktop.org/src/gst-rtsp-server/gst-rtsp-server-1.20.5.tar.xz"
  sha256 "ba398a7ddd559cce56ef4b91f448d174e0dccad98a493563d2d59c41a2ef39c5"
  license "LGPL-2.0-or-later"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-rtsp-server/"
    regex(/href=.*?gst-rtsp-server[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "692806bdb19705282ef6bf717e02b93adc94a9058304a40d0e68666270dd9e4b"
    sha256 cellar: :any, arm64_monterey: "b650527ebf1bbb38e41097204711c0cccbe11fa31fd451a118faec2920c79879"
    sha256 cellar: :any, arm64_big_sur:  "840b92c864f83bb0134bb60a9c7bc91b3ed0609b7cb80f57924198eade5dfe63"
    sha256 cellar: :any, ventura:        "98b228b7d0899134764fe25bc3579b97d430deb71cbc27e39b8fc6c497961c96"
    sha256 cellar: :any, monterey:       "8e9724b507f0db001b8c969021fe3aee82e4557c9fd5a4b81f39ff2eb97e2122"
    sha256 cellar: :any, big_sur:        "ecc0b1ada06392646aa1ee7f5240fad8e700856786d6f6fab57c47f462c25ece"
    sha256               x86_64_linux:   "3295fc435b4e0137381d33e67e2955866d281045906fb705d0dcc438a26ee74a"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gst-plugins-base"
  depends_on "gstreamer"

  def install
    args = std_meson_args + %w[
      -Dintrospection=enabled
      -Dexamples=disabled
      -Dtests=disabled
    ]

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    gst = Formula["gstreamer"].opt_bin/"gst-inspect-1.0"
    output = shell_output("#{gst} --gst-plugin-path #{lib} --plugin rtspclientsink")
    assert_match(/\s#{version}\s/, output)
  end
end
