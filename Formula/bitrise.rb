class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/2.1.0.tar.gz"
  sha256 "7369f27b4a8a66b8ee0c6013bdbe676fe545520672525c47e3a6c207248e4df3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a562e497bf03d12e8afed2ab4681a1abcfdfcea3eb3d8c6a0a970381f625c41"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e36db57ea4a22bd574d50d98303d2d713220318199d5d38e77262706d37c321a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "155543e353d18415595d0b705dcc1634a46be6de14f31842c35c93e3f67456bb"
    sha256 cellar: :any_skip_relocation, ventura:        "2a0f67f74300e959583d3be500083bbd69a20af92629c98424121fa4db00a108"
    sha256 cellar: :any_skip_relocation, monterey:       "2d88d732c4437743b081c0727bd6bcd745f60f0ae3f93febb5fb504809480a9a"
    sha256 cellar: :any_skip_relocation, big_sur:        "266ee7aa7731cc6420da9266401fa9304770478f8f90182b37ae32add5214d6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79d06b84dc6fa2a6e65400ad592dfa4a7830901b48221dea19ad07eae1769b70"
  end

  depends_on "go" => :build

  uses_from_macos "rsync"

  def install
    ldflags = %W[
      -s -w
      -X github.com/bitrise-io/bitrise/version.VERSION=#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags.join(" "))
  end

  test do
    (testpath/"bitrise.yml").write <<~EOS
      format_version: 1.3.1
      default_step_lib_source: https://github.com/bitrise-io/bitrise-steplib.git
      workflows:
        test_wf:
          steps:
          - script:
              inputs:
              - content: printf 'Test - OK' > brew.test.file
    EOS

    system "#{bin}/bitrise", "setup"
    system "#{bin}/bitrise", "run", "test_wf"
    assert_equal "Test - OK", (testpath/"brew.test.file").read.chomp
  end
end
