class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/2.0.2.tar.gz"
  sha256 "f59c866b751788bc77186191b664e6eef91ae5c715091eff76c4b5904ad9cb38"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19934a8a0d4edc8391dff3c6d223e1f3a896180d6687806c6d061ed515a311b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d86a919b4b3fa5889e4002739686e1a2d5d89a3ceb46c36fdeb22688ef9d10d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "29553ba495e8b9c7059eb203075bad350eab95761cfc220d14c1880bbabffeaf"
    sha256 cellar: :any_skip_relocation, ventura:        "6388155b03dd6a231dea06e6ffb4b81d7a8ba359b7213d5149cbaaa86ee5d96d"
    sha256 cellar: :any_skip_relocation, monterey:       "272688fc1f4c7d20a493c3a10f841aa39958de111dfe0ecb9dfb6254ec0234f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "d98a4f81f81737cccb7f09f315f834bc5f59b2c3b369b24da086ab80710a7be2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4a5d2afa713f4989340e4f056449912893f82e49369d70546167c900b9828eb"
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
