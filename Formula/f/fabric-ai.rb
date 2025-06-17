class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://mirror.ghproxy.com/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.205.tar.gz"
  sha256 "1b248565e6c26000e0162cdf5a89024d30769a1bdc027c3d25f634c1b67af9bd"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e240e450a6622b20cee635f6af6906170736d703fca3d68250c25f5a93e8fba2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e240e450a6622b20cee635f6af6906170736d703fca3d68250c25f5a93e8fba2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e240e450a6622b20cee635f6af6906170736d703fca3d68250c25f5a93e8fba2"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f8bc3093e3e773e45636557946503815a0c22eb161dfc32f09015d1d6463920"
    sha256 cellar: :any_skip_relocation, ventura:       "6f8bc3093e3e773e45636557946503815a0c22eb161dfc32f09015d1d6463920"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5865295889617579b3019b4226ef913ec614445ed22445bfe2355dcdeb27201"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fabric-ai --version")

    (testpath/".config/fabric/.env").write("t\n")
    output = shell_output("#{bin}/fabric-ai --dry-run < /dev/null 2>&1")
    assert_match "error loading .env file: unexpected character", output
  end
end
