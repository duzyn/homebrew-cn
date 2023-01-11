class Erigon < Formula
  desc "Implementation of Ethereum (execution client), on the efficiency frontier"
  homepage "https://github.com/ledgerwatch/erigon"
  url "https://github.com/ledgerwatch/erigon/archive/refs/tags/v2.33.1.tar.gz"
  sha256 "6a39ec9d5c6c2ebbad899cf93c29440392d86b116631ef2ce7dcbb7a536e5614"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/ledgerwatch/erigon.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74416ab00ef0be02c4b8d1cd9b109f5aabd67c03d626edb128e0f8714c56cf3b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "017ee5ae466767bdb6843d8179a61784197df1921eb0ccd1aca4b0601c11ff5f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f3722ca875cfdf59e0f0008b773a796ef76497326f417ca9e13ca7b74bea0821"
    sha256 cellar: :any_skip_relocation, ventura:        "6940a4dc5f593f44aa3f66c467ca291127da0c567f0d9dc2ed4cf646e153a82e"
    sha256 cellar: :any_skip_relocation, monterey:       "c35c192a37871300f9fd5a90102d2b1f11e5f2e710b6477d50ebed50b4190a15"
    sha256 cellar: :any_skip_relocation, big_sur:        "26da77a4243c2675b3c177f23d190b2f2f2a3020e7a37c38fc33fda2211e6f0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1edf677ffbfcc50ab5db57bd57c595c98e3fd101c90797dbca2890a65e7c294c"
  end

  depends_on "gcc" => :build
  depends_on "go" => :build
  depends_on "make" => :build

  def install
    unless build.head?
      ENV["GIT_COMMIT"] = "unknown"
      ENV["GIT_BRANCH"] = "release"
      ENV["GIT_TAG"] = "v#{version}"
    end

    system "make", "all"
    bin.install Dir["build/bin/*"]
  end

  test do
    (testpath/"genesis.json").write <<~EOS
      {
        "config": {
          "homesteadBlock": 10
        },
        "nonce": "0",
        "difficulty": "0x20000",
        "mixhash": "0x00000000000000000000000000000000000000647572616c65787365646c6578",
        "coinbase": "0x0000000000000000000000000000000000000000",
        "timestamp": "0x00",
        "parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
        "extraData": "0x",
        "gasLimit": "0x2FEFD8",
        "alloc": {}
      }
    EOS
    args = %W[
      --datadir testchain
      --log.dir.verbosity debug
      --log.dir.path #{testpath}
    ]
    system "#{bin}/erigon", *args, "init", "genesis.json"
    assert_predicate testpath/"debug-user.log", :exist?
  end
end
