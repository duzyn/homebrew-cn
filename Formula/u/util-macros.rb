class UtilMacros < Formula
  desc "X.Org: Set of autoconf macros used to build other xorg packages"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/util/util-macros-1.20.2.tar.xz"
  sha256 "9ac269eba24f672d7d7b3574e4be5f333d13f04a7712303b1821b2a51ac82e8e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "418d29093fca0889e64ecc830bd8d987269774aba25d302cf959338acc1363ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "418d29093fca0889e64ecc830bd8d987269774aba25d302cf959338acc1363ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "418d29093fca0889e64ecc830bd8d987269774aba25d302cf959338acc1363ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "61e34714606b0ade8be0c48e199d42bde8a7b0894af880d0abac628647438a85"
    sha256 cellar: :any_skip_relocation, ventura:       "61e34714606b0ade8be0c48e199d42bde8a7b0894af880d0abac628647438a85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "418d29093fca0889e64ecc830bd8d987269774aba25d302cf959338acc1363ac"
  end

  depends_on "pkg-config" => :test

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "pkg-config", "--exists", "xorg-macros"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
