class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.sh/"
  url "https://github.com/loft-sh/devspace.git",
      tag:      "v6.2.4",
      revision: "a13b5bde0ecf79835f8369a90eaddfa336c82e56"
  license "Apache-2.0"
  head "https://github.com/loft-sh/devspace.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "de510d9126cf6b6686b58a78de309c085b67f1e55ac0cc29600d7ab793c86e77"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4a6f3bd2bfaad6d6c6e31493a0682437a8bb70f401cc5773e16e01330654021"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8da38daaed60a0127b2bf59238993c266f40df17ab40da2be258ca203ea24a6e"
    sha256 cellar: :any_skip_relocation, ventura:        "a328311d9572f8e26cb688a9482f16a6dbbfab0a69e39b48bae4e068d031eded"
    sha256 cellar: :any_skip_relocation, monterey:       "90dfa3e41a656e480c3a810c000899ac1269bc307928bc532014461ea366bc8e"
    sha256 cellar: :any_skip_relocation, big_sur:        "e353ebb64fe52bf4fe522c9f59b74ce1eb9db73c3ddf98acc3c9fcf417b628ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "466e64de952967f5a457b5e83b276adbaaa36aef92890363a4aaea356f44434c"
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
