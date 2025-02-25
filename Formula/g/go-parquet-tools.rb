class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://mirror.ghproxy.com/https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.26.0.tar.gz"
  sha256 "c7e710b320525e9d464f1dce61e05fc1ca63aa905de32e333146e87e6fffd70a"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef019e400e6b25912997bd590dcf89d89ff96f47b60cf1c28795d27b7e343713"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef019e400e6b25912997bd590dcf89d89ff96f47b60cf1c28795d27b7e343713"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ef019e400e6b25912997bd590dcf89d89ff96f47b60cf1c28795d27b7e343713"
    sha256 cellar: :any_skip_relocation, sonoma:        "750d3e95a6ad26c37606670a7786bba932cafd2ef25f9870ab27864c031f4fe2"
    sha256 cellar: :any_skip_relocation, ventura:       "750d3e95a6ad26c37606670a7786bba932cafd2ef25f9870ab27864c031f4fe2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c2b1269b90f73ebd819582d6f0356b5a47d386ed048949c8225a95d52796a5f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/hangxie/parquet-tools/cmd.version=v#{version}
      -X github.com/hangxie/parquet-tools/cmd.build=#{time.iso8601}
      -X github.com/hangxie/parquet-tools/cmd.source=Homebrew
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"parquet-tools")
  end

  test do
    resource("test-parquet") do
      url "https://mirror.ghproxy.com/https://github.com/hangxie/parquet-tools/raw/950d21759ff3bd398d2432d10243e1bace3502c5/testdata/good.parquet"
      sha256 "daf5090fbc5523cf06df8896cf298dd5e53c058457e34766407cb6bff7522ba5"
    end

    resource("test-parquet").stage testpath

    output = shell_output("#{bin}/parquet-tools schema #{testpath}/good.parquet")
    assert_match "name=Parquet_go_root", output
  end
end
