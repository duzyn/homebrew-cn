class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://mirror.ghproxy.com/https://github.com/bitrise-io/bitrise/archive/refs/tags/v2.29.3.tar.gz"
  sha256 "aba325f5a2e19320787ec2869c88c530d0537932c8b18d19da944a24e21c9bf8"
  license "MIT"
  head "https://github.com/bitrise-io/bitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fbb4650bcf56e18bc91f7037c59bc049bbcfc6364ee68cc8cc80f82a5070fb8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fbb4650bcf56e18bc91f7037c59bc049bbcfc6364ee68cc8cc80f82a5070fb8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8fbb4650bcf56e18bc91f7037c59bc049bbcfc6364ee68cc8cc80f82a5070fb8"
    sha256 cellar: :any_skip_relocation, sonoma:        "b55b6628dfadc06e00c515ece16f52ebf5b5adc3827c0ee1304477dc788a3318"
    sha256 cellar: :any_skip_relocation, ventura:       "b55b6628dfadc06e00c515ece16f52ebf5b5adc3827c0ee1304477dc788a3318"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a9c09fce8308cd9617fb8d0dd62a41b9ed1bbadf066813002e5863dc522fc6c"
  end

  depends_on "go" => :build

  uses_from_macos "rsync"

  def install
    ldflags = %W[
      -s -w
      -X github.com/bitrise-io/bitrise/version.VERSION=#{version}
      -X github.com/bitrise-io/bitrise/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    (testpath/"bitrise.yml").write <<~YAML
      format_version: 1.3.1
      default_step_lib_source: https://github.com/bitrise-io/bitrise-steplib.git
      workflows:
        test_wf:
          steps:
          - script:
              inputs:
              - content: printf 'Test - OK' > brew.test.file
    YAML

    system bin/"bitrise", "setup"
    system bin/"bitrise", "run", "test_wf"
    assert_equal "Test - OK", (testpath/"brew.test.file").read.chomp
  end
end
