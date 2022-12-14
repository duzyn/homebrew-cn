class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.sh/"
  url "https://github.com/loft-sh/devspace.git",
      tag:      "v6.2.2",
      revision: "1371d3eaf6778d0131d71b16556517197e7366ca"
  license "Apache-2.0"
  head "https://github.com/loft-sh/devspace.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8dd1cd9877a6a4bd874559c4cfb78c2286577388989b9ee1a6796c315703fc2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "081404359aed7a8752c1db049630f241a6d7b2bf05b53c9c27b093f74c7bb8cd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6a1c047b720f18eafdc9c167d21c5c9ad8d5b07702b92134b1e17552c6ccfa75"
    sha256 cellar: :any_skip_relocation, ventura:        "d3ff3a26713af90d0ea2544ba53deeeac80e3dfd806766fa19d929a890995a30"
    sha256 cellar: :any_skip_relocation, monterey:       "20b8d238c7a399a29cac9a7e31a4574a3bb3237597f06975c16c96905a6308ca"
    sha256 cellar: :any_skip_relocation, big_sur:        "562d6ce4a87ea0b5947b2e82e99623a760b5978b8ad74fba9dd47305b75f1433"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d1b0f979e552e8afb70e333847cb7e7653c00444ede4eeecea1cbf9052ac3ae"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ldflags = %W[
      -s -w
      -X main.commitHash=#{Utils.git_head}
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"devspace", "completion")
  end

  test do
    help_output = "DevSpace accelerates developing, deploying and debugging applications with Docker and Kubernetes."
    assert_match help_output, shell_output("#{bin}/devspace --help")

    init_help_output = "Initializes a new devspace project"
    assert_match init_help_output, shell_output("#{bin}/devspace init --help")
  end
end
