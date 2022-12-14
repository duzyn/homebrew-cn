class Goctl < Formula
  desc "Generates server-side and client-side code for web and RPC services"
  homepage "https://go-zero.dev"
  url "https://github.com/zeromicro/go-zero/archive/refs/tags/tools/goctl/v1.4.3.tar.gz"
  sha256 "5b743e45d29f8f71833b33ade8dfb63edd6c726fe63270c0055c6436af17274c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "812b3cc90f6ab4a89c92c11ca2bc0fae725c4942c723feda6cdb2a16a26dc4d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "135fbafa6986dc77526ac8ade5378963aa4ccec735636048c9cc1332ecb5f5ab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c5aaf4a59f4a4d106e93149741fb3bb8d2cdb276353486502e5e3366faa010fc"
    sha256 cellar: :any_skip_relocation, ventura:        "7f6e59c07aa5f3d5ad26bc046978c0d2cc66a671666ef14bee59c84fb9253c4f"
    sha256 cellar: :any_skip_relocation, monterey:       "23bdc0656b6935bc7bc1fb01e94a2e470f37f4b120f322a9c8c20558d940ee3a"
    sha256 cellar: :any_skip_relocation, big_sur:        "eb1ff75c77f2cdbaf1f77c04b7712d5b8f4e403ebaa5a915e3c013f0a2d31845"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "641f54a3d8792ecec8ee23ba4bf5d27811e432ab92376cdc34cfd3c536e820c8"
  end

  depends_on "go" => :build

  def install
    chdir "tools/goctl" do
      system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"goctl"), "goctl.go"
    end

    generate_completions_from_executable(bin/"goctl", "completion")
  end

  test do
    assert_match "goctl version #{version}", shell_output("#{bin}/goctl --version")
    system bin/"goctl", "template", "init", "--home=#{testpath}/goctl-tpl-#{version}"
    assert_predicate testpath/"goctl-tpl-#{version}", :exist?, "goctl install fail"
  end
end
