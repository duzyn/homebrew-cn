class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-39.2.1.tgz"
  sha256 "050b911ade2e539363c31387394c1057b396576a3486b1ec9757283b1ebafef5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0366a13dd4370ab8013df9a5c73ae56aad534e666d01aba067971a342ee19fc1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0366a13dd4370ab8013df9a5c73ae56aad534e666d01aba067971a342ee19fc1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0366a13dd4370ab8013df9a5c73ae56aad534e666d01aba067971a342ee19fc1"
    sha256 cellar: :any_skip_relocation, sonoma:        "bedb93adedd353afab3c8823c90bca395314e07f23a40816333e1b8e6352caef"
    sha256 cellar: :any_skip_relocation, ventura:       "bedb93adedd353afab3c8823c90bca395314e07f23a40816333e1b8e6352caef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35b46cd1897b715bae864819cb5f7b16b4103c0dc716692931872d71f211fc9d"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "${await getUpdateCommand()}",
                               "brew upgrade vercel-cli"
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible deasync modules
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/vercel/node_modules"
    node_modules.glob("deasync/bin/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end
