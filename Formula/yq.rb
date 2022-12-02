class Yq < Formula
  desc "Process YAML, JSON, XML, CSV and properties documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.30.5.tar.gz"
  sha256 "54706926e44ca8f28c74c0165c4746f372daafd4db885b709fdaf5e8f2e4502c"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7dd1b8b56cda53ebc96a3e82f074c4784ceb847e64d00b11e6e51066e871e1da"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7c86e405a2617b3f7cc1e534740f2d66fc4d910115894eb9e7a561f2f81db58d"
    sha256 cellar: :any_skip_relocation, ventura:        "665b1d381d5fd909a162f5f597c0764ff0202779c9bd26ad1e5828c6699706e6"
    sha256 cellar: :any_skip_relocation, monterey:       "628af281d63ed5d4998cf4e54e75ae8913901e1ac61fefeca57ae436ff6d5163"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ac78f949c35abec4f59e56a4d309e2b7a21137d52b3a3c30ef1d8c5609f1850"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b7bb807c3b5d612255c4bfdf492cc7b252b976d86cc845530bfdf0591d0c23b"
  end

  depends_on "go" => :build
  depends_on "pandoc" => :build

  conflicts_with "python-yq", because: "both install `yq` executables"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    # Install shell completions
    generate_completions_from_executable(bin/"yq", "shell-completion")

    # Install man pages
    system "./scripts/generate-man-page-md.sh"
    system "./scripts/generate-man-page.sh"
    man1.install "yq.1"
  end

  test do
    assert_equal "key: cat", shell_output("#{bin}/yq eval --null-input --no-colors '.key = \"cat\"'").chomp
    assert_equal "cat", pipe_output("#{bin}/yq eval \".key\" -", "key: cat", 0).chomp
  end
end
