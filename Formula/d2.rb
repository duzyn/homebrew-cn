class D2 < Formula
  desc "Modern diagram scripting language that turns text to diagrams"
  homepage "https://d2lang.com/"
  url "https://github.com/terrastruct/d2/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "5aeeca3dcdc417b1756b6e92cbdbf8dd61214b880d2bf8586b6da5230338b091"
  license "MPL-2.0"
  head "https://github.com/terrastruct/d2.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a97d4f0383bdc42019e39d92f98a631d83d3b75f7158f6a3f47621b36dc92191"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a0a81f8fe054c5b1301338171ba6cdb81c50d69341dd5b05aebfcf63115887b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab63dab311c39dc6a625c0b56c328abaff8912aa8c6fad05394119d6bf426a09"
    sha256 cellar: :any_skip_relocation, ventura:        "efc2ed01e016cfbc355a54535ac502310c72c96babb465568fb9074adc119dc0"
    sha256 cellar: :any_skip_relocation, monterey:       "fcb52c2a9507aff9d2379308b2d65386fa44f8679f88876a28307fdbe824471b"
    sha256 cellar: :any_skip_relocation, big_sur:        "3c591c47c4a74112c2e2a85f954e20cc6c8cea61570ebb058d47ffe3206129ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e09d767be9bbee801176c3459e461ba355a0a9bd8fd278996170efd199563c2"
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
