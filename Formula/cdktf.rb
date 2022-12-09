require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.14.3.tgz"
  sha256 "eea5d55d6bc6f626c84900d34573928672c708d98b0dbabfc39b54d654de1cc5"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "319d096cc65b5c919d54d37f57a528f6e002d51c8a7b8e6e55d2eb19ae94f4b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "319d096cc65b5c919d54d37f57a528f6e002d51c8a7b8e6e55d2eb19ae94f4b8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "319d096cc65b5c919d54d37f57a528f6e002d51c8a7b8e6e55d2eb19ae94f4b8"
    sha256 cellar: :any_skip_relocation, ventura:        "0805f9990357595aea49bd028fc1256c31fbd65a12808a53fd0adb510b46feea"
    sha256 cellar: :any_skip_relocation, monterey:       "0805f9990357595aea49bd028fc1256c31fbd65a12808a53fd0adb510b46feea"
    sha256 cellar: :any_skip_relocation, big_sur:        "0805f9990357595aea49bd028fc1256c31fbd65a12808a53fd0adb510b46feea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "319d096cc65b5c919d54d37f57a528f6e002d51c8a7b8e6e55d2eb19ae94f4b8"
  end

  depends_on "node@18"
  depends_on "terraform"

  def install
    node = Formula["node@18"]
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"cdktf").write_env_script "#{libexec}/bin/cdktf", { PATH: "#{node.opt_bin}:$PATH" }

    generate_completions_from_executable(libexec/"bin/cdktf", "completion",
                                         shells: [:bash, :zsh], shell_parameter_format: :none)
  end

  test do
    assert_match "ERROR: Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdktf init --template='python' 2>&1", 1)
  end
end
