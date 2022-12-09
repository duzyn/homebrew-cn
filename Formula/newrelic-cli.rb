class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.60.5.tar.gz"
  sha256 "e9dfcc566d1b4e3a5e59544d7b9c01e696eb429cd9a62cd494c221c15db5d45f"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0df1864eb88d791934e3c2e3d11246cd94a9040db24e2e9f4e1431f1fa44cb2a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4773ee740f49f231e3d3a60c061a507d9671bd85993972b6c204d9b254d3720f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6a202ed10df59d71478d7bf377eaaa4c7636ecdfb485a9c593577b439281fbc1"
    sha256 cellar: :any_skip_relocation, ventura:        "cd7ef1426a57ec9389b6c425882ce46609d5181278ff7da41fa8f8304fa9a7a5"
    sha256 cellar: :any_skip_relocation, monterey:       "4c7c419558313068665ead8e3d66d0df956e3fa32f411c70df000c1ee0efe29c"
    sha256 cellar: :any_skip_relocation, big_sur:        "40c95079b7035ccb1df5b5d8886569ad46ec3fe245c96404b3e83d190e468228"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6b952a895747c6d7a68ff9a563d48921b868495cae0adcb5e9059a463b19177"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    generate_completions_from_executable(bin/"newrelic", "completion", "--shell", base_name: "newrelic")
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
