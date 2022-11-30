class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.182.tar.gz"
  sha256 "0656a3ba4c6d77b738e3dfdc19cc31d221aedd1badabb7b68afdf05bbb1e1000"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f20a61bfb576e667e7b1851ca7e6ea6895a0290048c2efc68aca9a315265fae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b28f095d3c6679daea28df03803bcef9798bb55e51178997465e5c24c4b9d459"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9de774df889b89fd9d26163244537a046d145d68dc7370da4a6843b306c1dd89"
    sha256 cellar: :any_skip_relocation, ventura:        "2d255f2481b739a4fc81d957259ee99a7444c0d4136db2003460c0c28d031c89"
    sha256 cellar: :any_skip_relocation, monterey:       "4bab2ac5a427ffc98d9c7e03345eb04c8d8da30ae668688e0303e4d2b5425fbd"
    sha256 cellar: :any_skip_relocation, big_sur:        "d584f1b194f0ae9b9e1d5d4edf2b9707f184ba91888f17cadda0f943b9ecff06"
    sha256 cellar: :any_skip_relocation, catalina:       "24143ed678e8aa1e17536fab14295ce06f667757355c7317f7d35901abbb5742"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ac76226d4e41a79f70b0153e07a6e2d078ee8b4d3897e4416816306d812bc20"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"brev", "completion")
  end

  test do
    system bin/"brev", "healthcheck"
  end
end
