class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://github.com/walles/moar/archive/refs/tags/v1.11.2.tar.gz"
  sha256 "a19ded848e3d8901911587ed7be504a0ea39533cea5d52d3dae33d69a12be054"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c47781e52908f8ece5b199ac75159a5f3ef5128d14f92e62bf249dbad6df3bef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c47781e52908f8ece5b199ac75159a5f3ef5128d14f92e62bf249dbad6df3bef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c47781e52908f8ece5b199ac75159a5f3ef5128d14f92e62bf249dbad6df3bef"
    sha256 cellar: :any_skip_relocation, ventura:        "2ba361127e80e2ddb4da5ee121c3bb9ce1e3b8787a0647de01db89f562dea44c"
    sha256 cellar: :any_skip_relocation, monterey:       "2ba361127e80e2ddb4da5ee121c3bb9ce1e3b8787a0647de01db89f562dea44c"
    sha256 cellar: :any_skip_relocation, big_sur:        "2ba361127e80e2ddb4da5ee121c3bb9ce1e3b8787a0647de01db89f562dea44c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f34092a96b7dc94ac560ed9872e332511ca2149e2c267bef45362f762950d012"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
    man1.install "moar.1"
  end

  test do
    # Test piping text through moar
    (testpath/"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}/moar test.txt").strip
  end
end
