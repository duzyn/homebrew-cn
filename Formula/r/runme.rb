class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://mirror.ghproxy.com/https://github.com/stateful/runme/archive/refs/tags/v3.8.2.tar.gz"
  sha256 "d4bd901548c11d7e8aafcac9288a674c42606d2252be83c7147f8190b12b7692"
  license "Apache-2.0"
  head "https://github.com/stateful/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86e48eee743601f2027859f75d86d6212da8edeab8e91dcded5b949001dae814"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86e48eee743601f2027859f75d86d6212da8edeab8e91dcded5b949001dae814"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "86e48eee743601f2027859f75d86d6212da8edeab8e91dcded5b949001dae814"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a68e29077a4d154c5500ca251777772123df09a36050d7143e243dfbf428623"
    sha256 cellar: :any_skip_relocation, ventura:       "5a68e29077a4d154c5500ca251777772123df09a36050d7143e243dfbf428623"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "566a8f1d670d617476d0d14978a54498de6584a83cdf328831845518d14478e6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/stateful/runme/v3/internal/version.BuildDate=#{time.iso8601}
      -X github.com/stateful/runme/v3/internal/version.BuildVersion=#{version}
      -X github.com/stateful/runme/v3/internal/version.Commit=#{tap.user}
    ]

    system "go", "build", "-o", bin, *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"runme", "completion")
  end

  test do
    system bin/"runme", "--version"
    markdown = (testpath/"README.md")
    markdown.write <<~EOS
      # Some Markdown

      Has some text.

      ```sh { name=foobar }
      echo "Hello World"
      ```
    EOS
    assert_match "Hello World", shell_output("#{bin}/runme run --git-ignore=false foobar")
    assert_match "foobar", shell_output("#{bin}/runme list --git-ignore=false")
  end
end
