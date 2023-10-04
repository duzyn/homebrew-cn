class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://ghproxy.com/https://github.com/turbot/steampipe/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "b75a4b6bf676487f7614de0e0eb7585100ddd6cd619f867a44e5948c917f6b65"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c1b91a4cc3032c8a345a5044b8640017ce743b66c0ffc104431f59d35ce32d0b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "21e548f9464523b127da3703c09e666cd75a73879de9394641fdc2d943dd6a08"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c6c9b11e669c8d856f28eb05fddef334c50c7e7c1df7cdf1fb4aa79780309cc"
    sha256 cellar: :any_skip_relocation, sonoma:         "f94f4cd283a7c7dad8eb5225120c3f5b56828e7137e9198f7ac0b1e82140a099"
    sha256 cellar: :any_skip_relocation, ventura:        "58c4a1d1689b04cf913ec68ab289647e38aaa4bb31e705f54e76e32a800828b2"
    sha256 cellar: :any_skip_relocation, monterey:       "35c951cb7ebb9a9b9c771bc12fa9617c23495a6c6492487793e759ebe91a0eed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fdf5ccadc15eb2ff357525407d2343948942d4290e92f0e3d87b7d5126db005"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"steampipe", "completion")
  end

  test do
    if OS.mac?
      output = shell_output(bin/"steampipe service status 2>&1", 255)
      assert_match "Error: could not create sample workspace", output
    else # Linux
      output = shell_output(bin/"steampipe service status 2>&1")
      assert_match "Steampipe service is not installed", output
    end
    assert_match "Steampipe v#{version}", shell_output(bin/"steampipe --version")
  end
end
