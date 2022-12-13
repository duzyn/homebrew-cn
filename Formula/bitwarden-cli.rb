require "language/node"

class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://registry.npmjs.org/@bitwarden/cli/-/cli-2022.11.0.tgz"
  sha256 "9c234a5b86d8f53503b96aa236da011b6c5af71a2c16f81a9e23aa1a6d9b6ce4"
  license "GPL-3.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1466950502a9152ee108b0b4c070799fa18742c667c52caf907cee4475999d5c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1466950502a9152ee108b0b4c070799fa18742c667c52caf907cee4475999d5c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1466950502a9152ee108b0b4c070799fa18742c667c52caf907cee4475999d5c"
    sha256 cellar: :any_skip_relocation, ventura:        "2c9ae76e972ea3e409be58a3a437f0b39b53c5f3fa5bcdb019832057566de8d0"
    sha256 cellar: :any_skip_relocation, monterey:       "2c9ae76e972ea3e409be58a3a437f0b39b53c5f3fa5bcdb019832057566de8d0"
    sha256 cellar: :any_skip_relocation, big_sur:        "2c9ae76e972ea3e409be58a3a437f0b39b53c5f3fa5bcdb019832057566de8d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1466950502a9152ee108b0b4c070799fa18742c667c52caf907cee4475999d5c"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]

    generate_completions_from_executable(bin/"bw", "completion", shell_parameter_format: :arg, shells: [:zsh])
  end

  test do
    assert_equal 10, shell_output("#{bin}/bw generate --length 10").chomp.length

    output = pipe_output("#{bin}/bw encode", "Testing", 0)
    assert_equal "VGVzdGluZw==", output.chomp
  end
end
