class Dbdeployer < Formula
  desc "Tool to deploy sandboxed MySQL database servers"
  homepage "https://github.com/datacharmer/dbdeployer"
  url "https://github.com/datacharmer/dbdeployer/archive/v1.71.0.tar.gz"
  sha256 "604f7f0c24c9a7400012c63d6df9a25306940599e271d6d1668b8cbd37c6103b"
  license "Apache-2.0"
  head "https://github.com/datacharmer/dbdeployer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4db7654089b4e3d4e03e0bc4e2f8078f6c8045d9957a3f4a4d0896261a79a580"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "228a73e2aeeff73b56ad1728f6411070ca66a419abd4dbe69666e4d2d89e7a12"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2995f945aece53aca6ad20344f47bdaa81a73f7de021615ae0a1c65fc8ad44bb"
    sha256 cellar: :any_skip_relocation, ventura:        "ce4e03db883ff940ba9cec841c0c02505815024ec24fc050023dd182923551b8"
    sha256 cellar: :any_skip_relocation, monterey:       "2778f3f76d43f06fe145af1fd6a273a39eb499f9a7be16814dd80643c018c64a"
    sha256 cellar: :any_skip_relocation, big_sur:        "ef00788de39d48db44fdc5a12f1d0f6a7db34adf223d9c7d4bbf719e908518f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f516c5f38473a1c4a3417ca7cec892067a3315aceba2e424ef32b8d62eef13ee"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    bash_completion.install "docs/dbdeployer_completion.sh"
  end

  test do
    shell_output("dbdeployer init --skip-shell-completion --skip-tarball-download")
    assert_predicate testpath/"opt/mysql", :exist?
    assert_predicate testpath/"sandboxes", :exist?
  end
end
