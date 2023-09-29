class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://ghproxy.com/https://github.com/massdriver-cloud/mass/archive/refs/tags/1.5.3.tar.gz"
  sha256 "a12e272f6cbebd22311eb9fe81d04a10eb296e561cbd7fed04f8040125855f7c"
  license "Apache-2.0"
  head "https://github.com/massdriver-cloud/mass.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4846c0cd41a7b6d765b4275af825669b9465f6d96f16fa4d89b0e1afa4458151"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79da88cd8348695fccf48096e036a62bba67e07338136a37d40cf185007859ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0250f9772d6d08a8400f376f2173daa36ac741f3c653108401d57fc8f5a08349"
    sha256 cellar: :any_skip_relocation, sonoma:         "d3a876a7948f3c05bcc44e6ab742c1d6c1776c45ffe7b36e0c90963fa3e64f0e"
    sha256 cellar: :any_skip_relocation, ventura:        "f4d52a838cd86d7f8e4dd35052d9e3f20a7939cff2537e20fadcc3de80f1269f"
    sha256 cellar: :any_skip_relocation, monterey:       "c161b84440d147967a22579c42cddbcbe1654552e20c6cd8871ff9c31e252323"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e6310cd76803287b03195ee90ef84c813801c104de8e43979c0b875abe23189"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/massdriver-cloud/mass/pkg/version.version=#{version}
      -X github.com/massdriver-cloud/mass/pkg/version.gitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"mass")
    generate_completions_from_executable(bin/"mass", "completion")
  end

  test do
    output = shell_output("#{bin}/mass bundle build 2>&1", 1)
    assert_match "Error: open massdriver.yaml: no such file or directory", output

    output = shell_output("#{bin}/mass bundle lint 2>&1", 1)
    assert_match "OrgID: missing required value: MASSDRIVER_ORG_ID", output

    assert_match version.to_s, shell_output("#{bin}/mass version")
  end
end
