class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://cog.run/"
  url "https://mirror.ghproxy.com/https://github.com/replicate/cog/archive/refs/tags/v0.11.4.tar.gz"
  sha256 "882f1c48c162fb411c8dae0beeb98a48aa323b5f2768ced776c2f26f50822ae8"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50e75af82b521fdc940f262743b72a7c76ce774e1b5578fb82956731317cdc41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50e75af82b521fdc940f262743b72a7c76ce774e1b5578fb82956731317cdc41"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "50e75af82b521fdc940f262743b72a7c76ce774e1b5578fb82956731317cdc41"
    sha256 cellar: :any_skip_relocation, sonoma:        "caf2177ead13746b42f26d537dbd9636b15ed3bb363d59a60ed2849cba3399c7"
    sha256 cellar: :any_skip_relocation, ventura:       "caf2177ead13746b42f26d537dbd9636b15ed3bb363d59a60ed2849cba3399c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1dfa2ef60232b54ab2b1bf7b027d3e93f20efc34bbd0599159050684e1c9d12b"
  end

  depends_on "go" => :build
  depends_on "python@3.13" => :build

  conflicts_with "cocogitto", because: "both install `cog` binaries"

  def python3
    "python3.13"
  end

  def install
    # Prevent Makefile from running `pip install build` by manually creating wheel.
    # Otherwise it can end up installing binary wheels.
    system python3, "-m", "pip", "wheel", "--verbose", "--no-deps", "--no-binary=:all:", "."
    (buildpath/"pkg/dockerfile/embed").install buildpath.glob("cog-*.whl").first

    ldflags = %W[
      -s -w
      -X github.com/replicate/cog/pkg/global.Version=#{version}
      -X github.com/replicate/cog/pkg/global.Commit=#{tap.user}
      -X github.com/replicate/cog/pkg/global.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cog"

    generate_completions_from_executable(bin/"cog", "completion")
  end

  test do
    system bin/"cog", "init"
    assert_match "Configuration for Cog", (testpath/"cog.yaml").read

    assert_match "cog version #{version}", shell_output("#{bin}/cog --version")
  end
end
