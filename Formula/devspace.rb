class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.sh/"
  url "https://github.com/loft-sh/devspace.git",
      tag:      "v6.2.3",
      revision: "c385a260b09d4bcf5925828a03d237a99861a225"
  license "Apache-2.0"
  head "https://github.com/loft-sh/devspace.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a006d27358025e4228bc90d5f822b3ebbeb2e10a8102cd499684cdd74474a863"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9f8c10d54800bc13980ac737207f7627d02620e406a73aada280f977c7effaf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "64c8d2539ddd09c6229251fef051b0728ffbe7987ba5eb49ca9609d12dd53191"
    sha256 cellar: :any_skip_relocation, ventura:        "b48fa229f0225de522f700c7c4fec88a3088b22f4d34d2e0553bf6753caede38"
    sha256 cellar: :any_skip_relocation, monterey:       "cd19b777d07b19566866289c4acac9b648f7e69b02ccafd9d73dbe999c8babc2"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ec7aa79d35b8215d5321b2f7e5a83c94c13c8a8bef0115f4bbed3781f298e70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "197109667cc198a6e770e096b3e52b13551b19d67b700915ae43d2af4d3baa36"
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
