class Yq < Formula
  desc "Process YAML, JSON, XML, CSV and properties documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.30.6.tar.gz"
  sha256 "320d0ce36d1dbe703b4cbdb28e9a927c1e87b157e8c05aeb078d6c9c1b0138ea"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32badcf78b54509e134e11d6b52447d53df92af0db95c95877baa27d5d15b34c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a7e7f0c6e49168618aeb575a8b0160cbdc28096172b8b90b7f94a3d27569ed9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d190c3437e018a19e35ab7a588f08679b7cd691870a69a7adf7d0c97858ce6f3"
    sha256 cellar: :any_skip_relocation, ventura:        "7da43854e6335cf7eca390647646d3f4561f759733046f504ceaf85a91c86451"
    sha256 cellar: :any_skip_relocation, monterey:       "6b5e98258fb5938d56049651f82f4b18cf85efc8a28d17b8523855d6421ee7a8"
    sha256 cellar: :any_skip_relocation, big_sur:        "c158d629f0e09daa9f14d441a7388f78dbb819a9b21aff2839879fdf66abc66a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f85fdc6c29538a9261fa550da38349df58445def1eb677ff7356ba4888a13bc0"
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
