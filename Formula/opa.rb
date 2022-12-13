class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.47.3.tar.gz"
  sha256 "2b5e577fe2f7e91e64628b7cbccdb33cce94baca1f669eb396db2edbce255789"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a220119daee93eb2e1833e2c37aaa31c7137840d12057f7d5a8dca480576f52"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "388e14ba3c18047d56b57cc406113d0f957e2b20f0c19037e2b8760ea35ac08c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c0130bcabede0b5e2c0b30829d496cbb8c3e5ff5557f331e4d98e6fe2265c6f"
    sha256 cellar: :any_skip_relocation, ventura:        "3dbaaa4e857c1c4f53af4df2197f03da2c1cd26de187b2c90b249af0f9f63314"
    sha256 cellar: :any_skip_relocation, monterey:       "5ab6f4cece329cc46125e1ade0c7881ba3b117e905e90d0e359ad33089dfcc1b"
    sha256 cellar: :any_skip_relocation, big_sur:        "baa803398f84f6ecc6d120627f1641872bbc730b6ea52914410a12ebb6c45a23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df84311d3480d51a1fd4b9bdb060db4348df372b921531855c914051c72f2710"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/open-policy-agent/opa/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
    system "./build/gen-man.sh", "man1"
    man.install "man1"

    generate_completions_from_executable(bin/"opa", "completion")
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
