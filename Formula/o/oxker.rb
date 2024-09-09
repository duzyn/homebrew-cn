class Oxker < Formula
  desc "Terminal User Interface (TUI) to view & control docker containers"
  homepage "https://github.com/mrjackwills/oxker"
  url "https://mirror.ghproxy.com/https://github.com/mrjackwills/oxker/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "b3c716a8dc5348d2cab3bb5c1779996847d70dd8b8628d57afdd5b1b24bd27d9"
  license "MIT"
  head "https://github.com/mrjackwills/oxker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "76af28cdbb61c74c04a4b6444b473a5779fb32fd2ab42b68604857ddd1a6d266"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "918f6815f787e6c9547ec4ea513d5aaf9def2e5e56b3f51cc0202610b7e2a6f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13e6386ea5a7e4a9f15ec9acfe195adaa7b6ecacc30293af77107fd92e06f8d2"
    sha256 cellar: :any_skip_relocation, sonoma:         "d89668c6210270a01a6880f5b40b734d0e94bf106c823b9a31b666cffd531922"
    sha256 cellar: :any_skip_relocation, ventura:        "ca76bb96dfedcd5726ba9895b2f57b14e05c249b1a0b9875fc0663cf6d049194"
    sha256 cellar: :any_skip_relocation, monterey:       "1138c56c773e9682481a79d010d5ef50ba32a403861bf88668bd954d98f7411f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3897be408100166892e57405ed2473e062d6f37274c122e2f370584b14991525"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output(bin/"oxker --version")

    assert_match "a value is required for '--host <HOST>' but none was supplied",
      shell_output(bin/"oxker --host 2>&1", 2)
  end
end
