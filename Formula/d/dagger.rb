class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://mirror.ghproxy.com/https://github.com/dagger/dagger/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "f26a51165d0deba7f07ade5b65fcab58dd1daf6c4edfd2fb4124bcf856da9ad3"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0bd2260252812100ab41a074b74c60ae94b081fe6fbcd7273b4e6f337169a86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0bd2260252812100ab41a074b74c60ae94b081fe6fbcd7273b4e6f337169a86"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b0bd2260252812100ab41a074b74c60ae94b081fe6fbcd7273b4e6f337169a86"
    sha256 cellar: :any_skip_relocation, sonoma:        "9347497d815a94f9516bcfd9a6b40803f7b3a022b5aa4ce7300b2c71e0584608"
    sha256 cellar: :any_skip_relocation, ventura:       "9347497d815a94f9516bcfd9a6b40803f7b3a022b5aa4ce7300b2c71e0584608"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14e6464d11bd1821825d109f6f1ed5a82e1fa6e729844deffea421cd7e98e323"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.com/dagger/dagger/engine.Version=v#{version}
      -X github.com/dagger/dagger/engine.Tag=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/dagger"

    generate_completions_from_executable(bin/"dagger", "completion")
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    assert_match "dagger v#{version}", shell_output("#{bin}/dagger version")

    output = shell_output("#{bin}/dagger query brewtest 2>&1", 1)
    assert_match "Cannot connect to the Docker daemon", output
  end
end
