class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://mirror.ghproxy.com/https://github.com/vektra/mockery/archive/refs/tags/v2.40.0.tar.gz"
  sha256 "0a82e3a4a72cdefd1fe4d0d666f8e3d857ab746b89b480a59078de3fc2b94010"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1e3de9375c6adfa0a958d93f22ddf24580e25521be0ec7a75b44ca79de59b019"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "424654ed5867d6549e989ef52fa6e29954a3e059422d8c12b1cd7d5ffbbcbadb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f7ce1bdcc136d70437e8a3155a3b49eb8265b2531fbdd49419d77be7532cc4b"
    sha256 cellar: :any_skip_relocation, sonoma:         "291b9873a5ccae84cf8ed4edf9b55710de9b641bbfc7a623cb3adab2186ac690"
    sha256 cellar: :any_skip_relocation, ventura:        "bce989b631ac27f9f22179f58daf440c8b7ca42cca2af6f27b591ecd3a45965b"
    sha256 cellar: :any_skip_relocation, monterey:       "8b092a781cfd8efc114b41a5510655cc16faea7d5656fb5ddd136a2cb9777400"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9df668d9c859662d3222a7bb2465302425b82924256e9ea1c68513218eaa2647"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/vektra/mockery/v2/pkg/logging.SemVer=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"mockery", "completion")
  end

  test do
    output = shell_output("#{bin}/mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=v#{version}", output

    output = shell_output("#{bin}/mockery --all --dry-run 2>&1")
    assert_match "INF Starting mockery dry-run=true version=v#{version}", output
  end
end
