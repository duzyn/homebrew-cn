class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https://github.com/tektoncd/cli"
  url "https://github.com/tektoncd/cli/archive/v0.29.0.tar.gz"
  sha256 "ac3a979cdcdbc42354d0245cba0a4ac4ebc5f332bcf90685dda941a28a224682"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db99ad614b3d13716199a50e0f76754e89b4cabe3df39fe07bf96ca859333d13"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "170e62ae0e4abb03b93d714c4d6b25960397e59e9d1ec8202e9d6468a5d09a2a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9414914cc9c446d9f7ff089df232cc44bf8d05dea4a9f23b8f72fa8d88fad375"
    sha256 cellar: :any_skip_relocation, ventura:        "6588b455beb7f0bfe3d07a9afe00c1a7f8cb68a7c2a5e4b2f16e94dccfb1f285"
    sha256 cellar: :any_skip_relocation, monterey:       "60155a4c5b22aeedef8c6b0de5b2026580ee01d00ca122dbc40bf711dee561e0"
    sha256 cellar: :any_skip_relocation, big_sur:        "29f864d69fbff5bc9eb28a0a2cff47a3ea63c10f79c82b90a9e1362420879ddf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "942a628b79ec084a7805c6acffeeba5b78e3ab3796310d960bc092b4c73ac85b"
  end

  depends_on "go" => :build

  def install
    system "make", "bin/tkn"
    bin.install "bin/tkn" => "tkn"

    generate_completions_from_executable(bin/"tkn", "completion", base_name: "tkn")
  end

  test do
    cmd = "#{bin}/tkn pipelinerun describe homebrew-formula"
    io = IO.popen(cmd, err: [:child, :out])
    assert_match "Error: Couldn't get kubeConfiguration namespace", io.read
  end
end
