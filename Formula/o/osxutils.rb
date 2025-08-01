class Osxutils < Formula
  desc "Collection of macOS command-line utilities"
  homepage "https://github.com/specious/osxutils"
  url "https://mirror.ghproxy.com/https://github.com/specious/osxutils/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "9c11d989358ed5895d9af7644b9295a17128b37f41619453026f67e99cb7ecab"
  license "GPL-2.0-or-later"
  head "https://github.com/specious/osxutils.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "740ef31720ead876a8af81736ee00b5e74e29c0e77b84c7d9702cc6c7460f6c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9fedf0f63481a28280cbca3c4f9aaa8a9d1cae884e4287290c80d5376108aea8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b0ede5abb14b36d57990316d9f77a47af1ba28bf3b11b908d0da7a5d2672e5c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba6b55b6d292736fcc636f2afdc9f36e357ff2c4634936a1c357ab292b7e7817"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c5d4050cda7e5ede43231c7195ffa1eb06bf5e3b5a1efa6acf8243a0e8ee424a"
    sha256 cellar: :any_skip_relocation, sonoma:         "ee76c0bc782077f10bc0ac79076f6bf37f99411cacba2f4bb45fd2fcafa6002e"
    sha256 cellar: :any_skip_relocation, ventura:        "1a2be836a80538dedfc42b2c0143a284c7ecc2c6b635815b52bb9f9f91dd8a59"
    sha256 cellar: :any_skip_relocation, monterey:       "7fdfadc1766c5cc042a64798dcc7aa4093bcb8e2abe4c0b7146f6564288282aa"
    sha256 cellar: :any_skip_relocation, big_sur:        "499d88a58e5ab8ed2fc23e8ef3bd9234849a3d9df34b0c6bdae4b425be70d97b"
    sha256 cellar: :any_skip_relocation, catalina:       "95f394fa7721dc587b75adcb0a698c32858bfabf04bb569b6bf6ab0d7f52fb03"
    sha256 cellar: :any_skip_relocation, mojave:         "744e327d1fb2183de8785880c3f7a127abdd896977e3d30cade00933ea137521"
    sha256 cellar: :any_skip_relocation, high_sierra:    "d665cbec1973b73e1e1d290014786b95d36d9cfe7028fd69fa37f698d18e81dd"
    sha256 cellar: :any_skip_relocation, sierra:         "8021183b4ad9c646920020e51446e555210bbb24e22da923557e1e0370353dfd"
    sha256 cellar: :any_skip_relocation, el_capitan:     "3bd65cf2550b709c111e31db7cb7d829a9260ed5dd35a682c370ed01593c1989"
  end

  depends_on :macos

  def install
    # workaround for newer clang
    # upstream bug report, https://github.com/specious/osxutils/issues/11
    ENV.append_to_cflags "-Wno-int-conversion" if DevelopmentTools.clang_build_version >= 1403

    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match "osxutils", shell_output(bin/"osxutils")
  end
end
