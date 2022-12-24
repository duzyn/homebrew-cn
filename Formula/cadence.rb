class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.31.0.tar.gz"
  sha256 "9a4a90f15e6b88e8d4742e90d52055f41bd23bd0a8f8e55190aecc0eba11f380"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "72f6a9b346c0017fc4da327d58d48a0f2b315f25eacf3df420439ff078029cbf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc6d19594a4340dbed77bea497a3c3387cdddd7b8265b60173362b6a3433edb5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c3b6307cfbda75c0dee8fee365357f21816785366b069c24de1f27ff6e965066"
    sha256 cellar: :any_skip_relocation, ventura:        "532502dcd63ab722f7f29b42eaddd9946b83d2b62063ff7c546cbf1a05f326cf"
    sha256 cellar: :any_skip_relocation, monterey:       "fcf38413e23d55cf82732cff1e7bb196dc89586ec4ad2db923ed31b295eca421"
    sha256 cellar: :any_skip_relocation, big_sur:        "41baf6e407759b49e47a0e0c06fa5a6ea5c920ee29ccab67c7b42a6f9f3f2dba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be74492238f34433775d457c326d4d00deac8cfeb47fe6a63f7f4d41af34373b"
  end

  depends_on "go" => :build

  conflicts_with "cadence-workflow", because: "both install a `cadence` executable"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./runtime/cmd/main"
  end

  test do
    (testpath/"hello.cdc").write <<~EOS
      pub fun main(): Int {
        return 0
      }
    EOS
    system "#{bin}/cadence", "hello.cdc"
  end
end
