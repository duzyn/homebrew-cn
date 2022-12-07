class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.60.4.tar.gz"
  sha256 "ed5e94b1a0c4d28a6b98fdfec3799f2d0a136e499460059c66ee20aaa67b772e"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d6ac39565024ccfa788f7048ba9e0fbca67abc731875776ee1ae788f898986a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f029adbe08730b80ede9d10a514faabe55b4b4f57d0d04968a1ef408b6c23fdf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8b888aef04816c47ad45a0226ee8ce24317eb4806b4da762d6a8f866de398f8f"
    sha256 cellar: :any_skip_relocation, ventura:        "8a33df9f6a897d14b603294667ce9aa2c877419621b7d43447615923cbc0e363"
    sha256 cellar: :any_skip_relocation, monterey:       "5ccc2e77bf8a41ab5ee1f2dcc532dd6679012748d1f311b6bef793a8e184b6da"
    sha256 cellar: :any_skip_relocation, big_sur:        "e9e361da455c8e025ce419d0b1493837866d2dedb62957f9685c43574d931c29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a6404eb7897ac3f802b071c037c6922a34213a331d87655aed64be34e21f248"
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
