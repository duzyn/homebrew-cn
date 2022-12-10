class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.60.6.tar.gz"
  sha256 "c7b02e96303bd9d55d328dca30fad72c4580b2a793eedd478f4f1ab35a928a49"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bfe16f1ff0e77d06397506ac332de411209d85453c0a272efd6b473609b505d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f2c512370792f121e5c8c2161cfe31c477dfedbefa8c2df476bf27e404cdb53"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c568c2baff1179948e898e79e69ef2b1921d55a9dbf7b7f8a01c29e9512d2f2"
    sha256 cellar: :any_skip_relocation, ventura:        "b6d63828254b554315a1c2eced9bd7c0eb8e847bd58b76e003f5bfe8e5da4304"
    sha256 cellar: :any_skip_relocation, monterey:       "8a94c282d0250c326d0cfd5afd239b8ec7f6efcef89f36bbcc276540a1270c1c"
    sha256 cellar: :any_skip_relocation, big_sur:        "853a869f10ba6203c318fe95a759f96bff6728ffc5e5d12e072db7a8c402de75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "823e21a92351ad6bdf0a0a606a1cc2599cd0265cd632b761687121d7c81b6216"
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
