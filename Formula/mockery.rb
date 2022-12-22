class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/v2.16.0.tar.gz"
  sha256 "7582dfdf75f0153d8ab98e299c99cc80e98c71aeb222a0097eb8e5af5da0d32e"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c25d086c3327b339814111f7993a9edb24c6aa083588ea6cf0dc3fc5e3cfb3a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c42e2584d3321bf424543dfdb982cbfe460fc2f49c03bfdf75452316a371f21b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "762886f1712e0b45dd8daa845b834dd1e8cef552119737b8882152cad6d6aefa"
    sha256 cellar: :any_skip_relocation, ventura:        "d1114c7c78290c8b15d4932e0b9c6427cc114ed4627ca2905dd60351e1c2e3c2"
    sha256 cellar: :any_skip_relocation, monterey:       "7ffe69325d7a2c70b3f198ea6c8b7f67df3fe8cbc33871fb96c6a706bae9120d"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae3198b9a0c3b8d3b38f3a273757dccbbaafd8ef6ee97f1a588a739a834c0381"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b85a80ca350a5a0144f46661ba902f738295b3c496a58073850ca88705af91db"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/vektra/mockery/v2/pkg/config.SemVer=v#{version}")

    generate_completions_from_executable(bin/"mockery", "completion")
  end

  test do
    output = shell_output("#{bin}/mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=v#{version}", output

    output = shell_output("#{bin}/mockery --all --dry-run 2>&1")
    assert_match "INF Walking dry-run=true version=v#{version}", output
  end
end
