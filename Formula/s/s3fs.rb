class S3fs < Formula
  desc "FUSE-based file system backed by Amazon S3"
  homepage "https://github.com/s3fs-fuse/s3fs-fuse/wiki"
  url "https://mirror.ghproxy.com/https://github.com/s3fs-fuse/s3fs-fuse/archive/refs/tags/v1.95.tar.gz"
  sha256 "0c97b8922f005500d36f72aee29a1345c94191f61d795e2a7b79fb7e3e6f5517"
  license "GPL-2.0-or-later"
  head "https://github.com/s3fs-fuse/s3fs-fuse.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b48ab8ae069a3d0fd449d9f69167064635ef5c6945f299dc7385a06812309473"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "curl"
  depends_on "gnutls"
  depends_on "libfuse@2"
  depends_on "libgcrypt"
  depends_on "libxml2"
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "nettle"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking", "--with-gnutls", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"s3fs", "--version"
  end
end
