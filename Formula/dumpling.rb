class Dumpling < Formula
  desc "Creating SQL dump from a MySQL-compatible database"
  homepage "https://github.com/pingcap/tidb"
  url "https://github.com/pingcap/tidb.git",
      tag:      "v6.5.0",
      revision: "706c3fa3c526cdba5b3e9f066b1a568fb96c56e3"
  license "Apache-2.0"
  head "https://github.com/pingcap/tidb.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "399afa4735f7f0bb6d51e093cdebab16dd4a65f9657fc4c602994f33957780c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e633576048a2cf32dde5f4a8de2fa8cbd46a447dce80ca2d6b7a1da609b5dd63"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "81d0269fac0681afc8802a16cd3a8c5acf65cb1da4eaac0b1bbf0821baea1c36"
    sha256 cellar: :any_skip_relocation, ventura:        "69f49dd47d3a017873071d9f68cd1ada316cb4bd18420c25c1f1d0d0084603ec"
    sha256 cellar: :any_skip_relocation, monterey:       "1150b4defd6b1b0d34af29928484e225bbd2fe2a31c1984adb8c0bf145ee8730"
    sha256 cellar: :any_skip_relocation, big_sur:        "98fd3ffea46a6dc3deebfc732c771357a3ac4a31df306da6d76852901edd3d1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11fec69ca3445f1bebe1d745b6f2d3000e195c526203b3f082213545b2b171d3"
  end

  depends_on "go" => :build

  def install
    project = "github.com/pingcap/tidb/dumpling"
    ldflags = %W[
      -s -w
      -X #{project}/cli.ReleaseVersion=#{version}
      -X #{project}/cli.BuildTimestamp=#{time.iso8601}
      -X #{project}/cli.GitHash=#{Utils.git_head}
      -X #{project}/cli.GitBranch=#{version}
      -X #{project}/cli.GoVersion=go#{Formula["go"].version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./dumpling/cmd/dumpling"
  end

  test do
    output = shell_output("#{bin}/dumpling --database db 2>&1", 1)
    assert_match "create dumper failed", output

    assert_match "Release version: #{version}", shell_output("#{bin}/dumpling --version 2>&1")
  end
end
