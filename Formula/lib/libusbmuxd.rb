class Libusbmuxd < Formula
  desc "USB multiplexor library for iOS devices"
  homepage "https://www.libimobiledevice.org/"
  url "https://mirror.ghproxy.com/https://github.com/libimobiledevice/libusbmuxd/releases/download/2.1.0/libusbmuxd-2.1.0.tar.bz2"
  sha256 "c35bf68f8e248434957bd5b234c389b02206a06ecd9303a7fb931ed7a5636b16"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "5d4892dedecd97caba1f56522add5e601b4bc09ccea572c7c9b3ff84bd14744a"
    sha256 cellar: :any,                 arm64_sonoma:   "8149dcd7d29cdf463c40a10e8030dcb23a4eb9e69078a88fb2e8671d9a27bdad"
    sha256 cellar: :any,                 arm64_ventura:  "3908c3a4d699d2aff22b40e6353c498042153a47798357c4500b76b495f24e88"
    sha256 cellar: :any,                 arm64_monterey: "738b1efb11135136a9066ee73379829f29c57df598e989631d26e4ae5401f456"
    sha256 cellar: :any,                 sonoma:         "9b366b324e9758bd9f5d10c536e40ef2d90ed2caf2886ff7e55e13fe496628dd"
    sha256 cellar: :any,                 ventura:        "b188d3fcab748c6ac1e5740129bf4a07b2756dedd557d89f6f1291715bf6c45e"
    sha256 cellar: :any,                 monterey:       "4ea63ce7da1344b4e2fde47b7c2a9d8bad424bd5ce9282f6af1aa66a1155135b"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "84338459d26e427bd4a56a6f2c3e15a98f7dc4fa667d62ad4d77d2b052a193b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3e9212633194e2e9436afd98d00fd5e167ec0ff13f1abfd065112dd2dd32bd3"
  end

  head do
    url "https://github.com/libimobiledevice/libusbmuxd.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "libimobiledevice-glue"
  depends_on "libplist"

  def install
    configure = build.head? ? "./autogen.sh" : "./configure"
    system configure, "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    source = free_port
    dest = free_port

    PTY.spawn(bin/"iproxy", "-s", "localhost", "#{source}:#{dest}") do |r, w, pid|
      assert_match "Creating listening port #{source} for device port #{dest}", r.readline
      assert_match "waiting for connection", r.readline
      TCPSocket.new("localhost", source).close
      assert_match "New connection for #{source}->#{dest}", r.readline
    ensure
      r.close
      w.close
      Process.wait(pid)
    end
  end
end
