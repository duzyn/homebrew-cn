class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://mirror.ghproxy.com/https://github.com/runmedev/runme/archive/refs/tags/v3.12.7.tar.gz"
  sha256 "26fa831b2848d75de42f9f48cfbe3c15ee6624336dc747cd3c52763bb76d3f35"
  license "Apache-2.0"
  head "https://github.com/stateful/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9077a299edd0efa813c60bc0828d6040f79ab4517c35445b96cff919e5f8bcf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9077a299edd0efa813c60bc0828d6040f79ab4517c35445b96cff919e5f8bcf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d9077a299edd0efa813c60bc0828d6040f79ab4517c35445b96cff919e5f8bcf"
    sha256 cellar: :any_skip_relocation, sonoma:        "85d78447f39d4715ef2687e0240d99fbe12495532afc94e3ddb8f8a3ed4f2768"
    sha256 cellar: :any_skip_relocation, ventura:       "85d78447f39d4715ef2687e0240d99fbe12495532afc94e3ddb8f8a3ed4f2768"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65684ce59bb44cf7a74ac1097f8e5ae90681ecb2789538a6db7bd2996548bdd5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/stateful/runme/v3/internal/version.BuildDate=#{time.iso8601}
      -X github.com/stateful/runme/v3/internal/version.BuildVersion=#{version}
      -X github.com/stateful/runme/v3/internal/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"runme", "completion")
  end

  test do
    system bin/"runme", "--version"
    markdown = (testpath/"README.md")
    markdown.write <<~MARKDOWN
      # Some Markdown

      Has some text.

      ```sh { name=foobar }
      echo "Hello World"
      ```
    MARKDOWN
    assert_match "Hello World", shell_output("#{bin}/runme run --git-ignore=false foobar")
    assert_match "foobar", shell_output("#{bin}/runme list --git-ignore=false")
  end
end
