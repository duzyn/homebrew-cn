require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-17.5.0.tgz"
  sha256 "bae776ef22d55276e6162eb141cb741289c6cb3cdaa53ab94c5a245aa9ac0782"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "80fe8f0a12311b93c37c33e1a838ba6af3be8ec4eadc5090dec4a2320bcf1e62"
    sha256                               arm64_ventura:  "7663fd44bfd303762fe2b577fd37aa56db2919eb65afba94ff0b9ae47e00f42c"
    sha256                               arm64_monterey: "e14ee73860cbf25a40ac12a2d839d4268bed89937803d0ff6758b78b3c72aec2"
    sha256                               sonoma:         "2737a395697780030876d2c2024802d43456576f7b484fd33a07c926944d6b28"
    sha256                               ventura:        "293d531b659c9850b1b9bee8981ea4412eae2db68d86ab09f89fc7067ea7acda"
    sha256                               monterey:       "0b7ccab311925e8e9e8a180efd468790d914db095f4e7408e722cf16850cd067"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39ef35aef43606327f5e660c448143ad2ded94a1a71070f4bc5a8fec102dcaf6"
  end

  depends_on "node"

  on_linux do
    depends_on "vips"
    depends_on "xsel"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    node_modules = libexec/"lib/node_modules/netlify-cli/node_modules"

    if OS.linux?
      (node_modules/"@lmdb/lmdb-linux-x64").glob("*.musl.node").map(&:unlink)
      (node_modules/"@msgpackr-extract/msgpackr-extract-linux-x64").glob("*.musl.node").map(&:unlink)
      (node_modules/"@parcel/watcher-linux-x64-musl/watcher.node").unlink
    end

    clipboardy_fallbacks_dir = node_modules/"clipboardy/fallbacks"
    clipboardy_fallbacks_dir.rmtree # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end
  end

  test do
    assert_match "Not logged in. Please log in to see site status.", shell_output("#{bin}/netlify status")
  end
end
