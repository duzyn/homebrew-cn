class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/swsnr/mdcat"
  url "https://github.com/swsnr/mdcat/archive/refs/tags/mdcat-0.30.3.tar.gz"
  sha256 "e4f96b9df490d1a1b11d8a7c84ef5636b242d3f3d5fe5fae1ab53847a80a7eba"
  license "MPL-2.0"
  head "https://github.com/swsnr/mdcat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f18e01786b66b786993c8bd0857236e7075b9cc5c83092f3e8d578072211e5bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f56b2a0fa7c1ecae445f8493ed3f70f6b05f06201faef3c2d7cff5b7f2db577d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f6a683545db10d68bf676f3042d629642625b8834a09f4c38b98ecd6db6de10f"
    sha256 cellar: :any_skip_relocation, ventura:        "e626b7e973048df30ed08c57e994f05c546ac5df8e333cfab07d291410b44659"
    sha256 cellar: :any_skip_relocation, monterey:       "173881ea4f542de79fc35b0434118a258d404a5fb6dbb35ce719ce27406cfbe3"
    sha256 cellar: :any_skip_relocation, big_sur:        "bec1c621dde3e8828bb77512a5d4b537c05daadfb80dd1ba7ccd2ef11aa3cf08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2826454b1001c9376445799ea45d9c67877d117dfa938f4651702c1bc4a3972"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.md").write <<~EOS
      _lorem_ **ipsum** dolor **sit** _amet_
    EOS
    output = shell_output("#{bin}/mdcat --no-colour test.md")
    assert_match "lorem ipsum dolor sit amet", output
  end
end
