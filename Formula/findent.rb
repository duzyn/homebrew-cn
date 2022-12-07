class Findent < Formula
  desc "Indent and beautify Fortran sources and generate dependency information"
  homepage "https://www.ratrabbit.nl/ratrabbit/findent/index.html"
  url "https://downloads.sourceforge.net/project/findent/findent-4.2.5.tar.gz"
  sha256 "bb8b8852a43444a4fe9bc2dc94dba59bff9912f0fb7df2a1af70f1012d211a59"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{url=.*?/findent[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44207704b0980c9ff393961c7305e0a717b76ec2355b18f8a92832c4f032cb8f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd726414fb47e9010b80d63c8c1dbab0b0f0add697eaabc67b7df646849caa08"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c56e1f5881b9b0739a2b8f7bac6a3a7ac0e4d2055522bcb118c2a4ea640a76c2"
    sha256 cellar: :any_skip_relocation, ventura:        "b2b6a5557e3026c52234c9f82c2b78644af6e214b9725aee3e5d66ad89ee8986"
    sha256 cellar: :any_skip_relocation, monterey:       "c06136465f4918536c512cddba2ca7755aa82cca8030482ba6390ac756e0d218"
    sha256 cellar: :any_skip_relocation, big_sur:        "2164562c32eb9096bf27f17e517f1f4856cc55f037d6365eafea07b995e8f25b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bf813a22ef25bfba698c996a626d54739e03cc1861057e0075f43c6272d30ea"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
    (pkgshare/"test").install %w[test/progfree.f.in test/progfree.f.try.f.ref]
  end

  test do
    cp_r pkgshare/"test/progfree.f.in", testpath
    cp_r pkgshare/"test/progfree.f.try.f.ref", testpath
    flags = File.open(testpath/"progfree.f.in", &:readline).sub(/ *! */, "").chomp
    system "#{bin}/findent #{flags} < progfree.f.in > progfree.f.out.f90"
    assert_predicate testpath/"progfree.f.out.f90", :exist?
    assert compare_file(testpath/"progfree.f.try.f.ref", testpath/"progfree.f.out.f90")
  end
end
