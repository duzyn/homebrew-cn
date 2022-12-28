class D2 < Formula
  desc "Modern diagram scripting language that turns text to diagrams"
  homepage "https://d2lang.com/"
  url "https://github.com/terrastruct/d2/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "9dc8c88d07725d549b8a20ae3271e82b01c0c45b0c7338a1ec67aad0c4facc54"
  license "MPL-2.0"
  head "https://github.com/terrastruct/d2.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2105d4626a007d89bb8c2f08427cca86245bc74386440d96e35beca7fa49a1b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d87fe206f9c3a8dc28db372bd5e3fd5df1bb7b53ee3d80db7f63a445b7095d77"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b86fce8c81a0e78d97a13516552d8ca6e4921c0268c39f6881557f8bd212d833"
    sha256 cellar: :any_skip_relocation, ventura:        "0baf18608798dbd84b9117756c8cc61082a36f0501f4e39a7e717a422b2558d1"
    sha256 cellar: :any_skip_relocation, monterey:       "30515da4f96e47c7176e57f7b1fbb94087f471adf953f8edaf23dda1c635a6c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "7e7073c2367ad9185d4f5c23adf9d9afd2517569360d90a5cba01f09bfa30ce0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4daceb026e2d6632516fa3303e4acec975dc8f54a47f178a187a2a2e8988e02f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X oss.terrastruct.com/d2/lib/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
    man1.install "ci/release/template/man/d2.1"
  end

  test do
    test_file = testpath/"test.d2"
    test_file.write <<~EOS
      homebrew-core -> brew: depends
    EOS

    system bin/"d2", test_file
    assert_predicate testpath/"test.svg", :exist?

    assert_match "dagre is a directed graph layout library for JavaScript",
      shell_output("#{bin}/d2 layout dagre")

    assert_match version.to_s, shell_output("#{bin}/d2 version")
  end
end
