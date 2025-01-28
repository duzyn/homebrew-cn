class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://mirror.ghproxy.com/https://github.com/aziontech/azion/archive/refs/tags/2.5.2.tar.gz"
  sha256 "f1ab7962a1bb5a0d3806aebe0716bd1e839522f4b81591dba152e0ba3e9adcb9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4aec0ffe5ab9f691f41bc35c0fb2312f34866aaad77c6e4770e79d3013682894"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4aec0ffe5ab9f691f41bc35c0fb2312f34866aaad77c6e4770e79d3013682894"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4aec0ffe5ab9f691f41bc35c0fb2312f34866aaad77c6e4770e79d3013682894"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c090261836e6c131da61c4dc682c6682ca5a684d3682e2f711b23090ef0816e"
    sha256 cellar: :any_skip_relocation, ventura:       "0c090261836e6c131da61c4dc682c6682ca5a684d3682e2f711b23090ef0816e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41f41b1d2c28fafaf46d0466d552c3258d981e628f74d103069831be9df2595f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/aziontech/azion-cli/pkg/cmd/version.BinVersion=#{version}
      -X github.com/aziontech/azion-cli/pkg/constants.StorageApiURL=https://api.azion.com
      -X github.com/aziontech/azion-cli/pkg/constants.AuthURL=https://sso.azion.com/api
      -X github.com/aziontech/azion-cli/pkg/constants.ApiURL=https://api.azionapi.net
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/azion"

    generate_completions_from_executable(bin/"azion", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azion --version")
    assert_match "Failed to build your resource", shell_output("#{bin}/azion build --yes 2>&1", 1)
  end
end
