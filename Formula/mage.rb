class Mage < Formula
  desc "Make/rake-like build tool using Go"
  homepage "https://magefile.org"
  url "https://github.com/magefile/mage.git",
      tag:      "v1.15.0",
      revision: "9e91a03eaa438d0d077aca5654c7757141536a60"
  license "Apache-2.0"
  head "https://github.com/magefile/mage.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5edee3b01ecc1dc26cf07372e9cbcfd7bc0c6c98ad8f5d89ab6255efe1af28c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5edee3b01ecc1dc26cf07372e9cbcfd7bc0c6c98ad8f5d89ab6255efe1af28c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d5edee3b01ecc1dc26cf07372e9cbcfd7bc0c6c98ad8f5d89ab6255efe1af28c"
    sha256 cellar: :any_skip_relocation, ventura:        "0fe71622f956586e54e08ec69f49dd719c16bca43fe62370720f32e8cb015a71"
    sha256 cellar: :any_skip_relocation, monterey:       "0fe71622f956586e54e08ec69f49dd719c16bca43fe62370720f32e8cb015a71"
    sha256 cellar: :any_skip_relocation, big_sur:        "0fe71622f956586e54e08ec69f49dd719c16bca43fe62370720f32e8cb015a71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4c08f1a7d6d80eeda6054fcdaea66ef2d344a952d9e249561781f8fabe54fff"
  end

  depends_on "go"

  def install
    ldflags = %W[
      -s -w
      -X github.com/magefile/mage/mage.timestamp=#{time.iso8601}
      -X github.com/magefile/mage/mage.commitHash=#{Utils.git_short_head}
      -X github.com/magefile/mage/mage.gitTag=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match "magefile.go created", shell_output("#{bin}/mage -init 2>&1")
    assert_predicate testpath/"magefile.go", :exist?
  end
end
