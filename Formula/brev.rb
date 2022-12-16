class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.197.tar.gz"
  sha256 "1a25e9e6935c3dbbd85a5fdee823bf0f2c63d00ca857d82c84d4cd9bc93900d6"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "428b45125897bcaff35df7f81c70398c348d7100d7abcfc27627ac30a08dab6f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad16fd37fccb9d8c5d40f2406e551d7af93a95448601027643c7ced4ef2ca942"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "734356a5c00bcb33b5b68faa967624e98d2f451e2287e4ca6247d23cef7069cf"
    sha256 cellar: :any_skip_relocation, ventura:        "8b495f9c0d954b93af33f603090b1eb13e0093fa41463282fce9db36bdf6ed38"
    sha256 cellar: :any_skip_relocation, monterey:       "6b1c74ce74e49b5467753d6c38ecbeeb8c8cbf2882fbc4728224450f42ebb8dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "f4c55afa3db9956174e16e932807249fd4276371bb220dd0bcafcd81a6d046ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2def1d8a6f99b2c54ad021abc8d9ea47e65f1c49ee85d60fa16515540edf32a9"
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
