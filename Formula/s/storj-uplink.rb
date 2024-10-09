class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://mirror.ghproxy.com/https://github.com/storj/storj/archive/refs/tags/v1.114.5.tar.gz"
  sha256 "cd5027d948958e39dc9d638156b2fb5c7d0e70a8f94703de565bc17eb9596e60"
  license "AGPL-3.0-only"

  # Upstream creates stable releases and marks them as "pre-release" before
  # release (though some versions have permanently remained as "pre-release"),
  # so it's necessary to check releases. However, upstream has not marked
  # recent releases as "latest", so it's necessary to check all releases.
  # NOTE: We should return to using the `GithubLatest` strategy if/when
  # upstream reliably marks stable releases as "latest" again.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fdfe84d8936311de09b0e85a03ffde2abb63cf16ab19dba256c539dc38216fde"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fdfe84d8936311de09b0e85a03ffde2abb63cf16ab19dba256c539dc38216fde"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fdfe84d8936311de09b0e85a03ffde2abb63cf16ab19dba256c539dc38216fde"
    sha256 cellar: :any_skip_relocation, sonoma:        "c2e50c12367f4fc729cc4395922fe7afa383fb88b39d3af9646a5a04eff9b4e0"
    sha256 cellar: :any_skip_relocation, ventura:       "c2e50c12367f4fc729cc4395922fe7afa383fb88b39d3af9646a5a04eff9b4e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "683ee85f6d8d9a81153f70fb4503a37ddcc1dd8144b26f0bf54d62bdbf679221"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"uplink"), "./cmd/uplink"
  end

  test do
    (testpath/"config.ini").write <<~EOS
      [metrics]
      addr=
    EOS
    ENV["UPLINK_CONFIG_DIR"] = testpath.to_s
    ENV["UPLINK_INTERACTIVE"] = "false"
    assert_match "No accesses configured", shell_output("#{bin}/uplink ls 2>&1", 1)
  end
end
