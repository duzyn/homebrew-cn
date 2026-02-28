class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.25.2.tgz"
  sha256 "86083a4d3972699a3f79dabd6434630360877ab1909c41223c55e738c309ed47"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bd6dc5afb53490b6ca895057eb179a2bbc9739b303e7e00b45f9ab5934e4499b"
    sha256 cellar: :any,                 arm64_sequoia: "d0f76aca282bb2b42ea62609a1a661668cf98c45d494786691e1bfc1f81f03c0"
    sha256 cellar: :any,                 arm64_sonoma:  "d0f76aca282bb2b42ea62609a1a661668cf98c45d494786691e1bfc1f81f03c0"
    sha256 cellar: :any,                 sonoma:        "6fa755f8b9f84383118bcb81e42119d9df7ecc5f0970ae9ff698326c004d62a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42bce76c51b19ceddffdf5b79cccf40fe81e18acdee7f709f06a7ede036080da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d1c00bf0bde8f4273f45d81020e5e58cea151100760780a89ba7872890b5546"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel-cli"'

    system "npm", "install", *std_npm_args
    deuniversalize_machos libexec/"lib/node_modules/vercel/node_modules/fsevents/fsevents.node" if OS.mac?
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end
