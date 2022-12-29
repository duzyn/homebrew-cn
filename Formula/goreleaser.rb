class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v1.14.0",
      revision: "33528d701a0c903dd4db806a2bc091a5d1a19897"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9339526b76b8eafe4860db38df15bb6c8a8a33a49b286ed9db1ac3e12976040e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bbd593d34649b0689fa8be04b96bd9f4c9271dabff27f328dfbca42d5fbbf0e1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "87de7b26264017c674c33ac2de6fb9185693f7d3f9354862870f979bb47aa16e"
    sha256 cellar: :any_skip_relocation, ventura:        "dfbdb3585142f0e56778c4b71b9d983b4481e8bbec95c92da19d78daa6a9f1be"
    sha256 cellar: :any_skip_relocation, monterey:       "e98d55a431e61fbe5832e790f2b3175524987070f451c6549089be19652ae1e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "44d15b9b48ee58c3a83b38255902c8776ed307bd9cbc36703974c86f84e69ca3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c530c896ca0c3a733fe3c896f89f65f6f0b6ab61a79cdd42def33140a41500bb"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.builtBy=homebrew
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)

    # Install shell completions
    generate_completions_from_executable(bin/"goreleaser", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end
