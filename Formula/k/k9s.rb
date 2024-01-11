class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.31.3",
      revision: "268def283495d8aeb3a5bf8bc2e9b2d21fe230e5"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "598f4fd19bb5f59fc4592b275467d552a7320b7c422c693229db152a5b808fd2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cea9a1b5c518aff21b2ab30d67778b1734cd290337a548ea4bf416010d6b9124"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a26ca061c82458e87b1ef3750f004bcd64957464e762f90d2471adff00dcf4e8"
    sha256 cellar: :any_skip_relocation, sonoma:         "39db403159b7d1f228c55e7f20a83486ab3d08254e0cbd87f42a9e17a65ce023"
    sha256 cellar: :any_skip_relocation, ventura:        "917ebc42b9515d55aaade8a18c7c3ac9f0d486eef182f890a29c0a2ff4a87c48"
    sha256 cellar: :any_skip_relocation, monterey:       "d00c10d59bccf374f44397ec8b9d9a281c81e8141efbd2af1e41537b88490374"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2bd8daa74566cea8769e067c530c7291930e8ed90597e591baa4d829df137b9c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/derailed/k9s/cmd.version=#{version}
      -X github.com/derailed/k9s/cmd.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"k9s", "completion")
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}/k9s --help")
  end
end
