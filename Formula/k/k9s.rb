class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.29.0",
      revision: "a44cb6135c1fec94e3777af2cb6aedcb8f18207d"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b7b7f5c513e72f4e72e9a804ea14dc14cc37a882b118d6450e3b90c5eee0b8ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec92421b910601c201a05d032a4b30d69a3b1eae85241ded415fc01cce2460fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d271e98180f7cd31eaa4f8575b27332ebdb349ac5d2781fda09c1f4ee44262a5"
    sha256 cellar: :any_skip_relocation, sonoma:         "edde53d90db297decdde9a01fb2c693ca8e931b662af2d116a45e30aeff6b91b"
    sha256 cellar: :any_skip_relocation, ventura:        "39b6e41754cb0ea5367adcf975e19c72ab7a53def84059702439e37ab8b57494"
    sha256 cellar: :any_skip_relocation, monterey:       "e791a3ac80488f50ec595b25e405f760ca22d8d55d9aa53bc0ed6bb755e84086"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40e2e40f3b0071a2c9eafe1c3c16599179bc0ab9973b25143359f2d55ce1971c"
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
