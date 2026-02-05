class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-23.15.0.tgz"
  sha256 "3fa344287f71e5b4ed88534d75c03c87f8f2c7089c9798d9c58d4e085c1523fb"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "063ce19c9b6536848358f53c05e2140a72b02a8434c327fb9af2eebbf2469229"
    sha256                               arm64_sequoia: "55afd0ba1041e66b54a17db7b146956e1037f16470cdfce79e3a30b50240b7ff"
    sha256                               arm64_sonoma:  "b2d171f5d25782d99b62d2212dea51e6b104ba082c4fd59a5f09c700ac4de7db"
    sha256                               sonoma:        "05ca5241277fa1e3d86b11a99d61541cee0de20ae926e055b232faab2f4451c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "951b37c6b0ba61b33b945be644dd68b336bf7fc13bf451b58cbfa87f4f9598fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "886cd9364edfa971588db5177e4591fd25bf73b9be1916f86b02d5684dbc6977"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "node"
  depends_on "vips"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "gmp"
    depends_on "xsel"
  end

  # Resource needed to build sharp from source to avoid bundled vips
  # https://sharp.pixelplumbing.com/install/#building-from-source
  resource "node-gyp" do
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-12.2.0.tgz"
    sha256 "8689bbeb45a3219dfeb5b05a08d000d3b2492e12db02d46c81af0bee5c085fec"
  end

  def install
    ENV["SHARP_FORCE_GLOBAL_LIBVIPS"] = "1"
    system "npm", "install", *std_npm_args(ignore_scripts: false), *resources.map(&:cached_download)
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible and unneeded pre-built binaries
    node_modules = libexec/"lib/node_modules/netlify-cli/node_modules"
    rm_r(node_modules.glob("@img/sharp-*"))
    rm_r(node_modules.glob("@parcel/watcher-{darwin,linux}*"))

    clipboardy_fallbacks_dir = node_modules/"clipboardy/fallbacks"
    rm_r(clipboardy_fallbacks_dir) # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end
  end

  test do
    assert_match "Not logged in. Please log in to see project status.", shell_output("#{bin}/netlify status")

    require "utils/linkage"
    sharp = libexec.glob("lib/node_modules/netlify-cli/node_modules/sharp/src/build/Release/sharp-*.node").first
    libvips = Formula["vips"].opt_lib/shared_library("libvips")
    assert sharp && Utils.binary_linked_to_library?(sharp, libvips),
           "No linkage with #{libvips.basename}! Sharp is likely using a prebuilt version."
  end
end
