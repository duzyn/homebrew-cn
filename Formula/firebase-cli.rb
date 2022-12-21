require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-11.19.0.tgz"
  sha256 "076ecce3116ae29de7ea1ef3683909c6833f5e00542af4b303ea744c0c48e963"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_ventura:  "9f7b21048c2fb03cbd88f6561ad1c217744c6e203bb0ad793723a80eab656281"
    sha256                               arm64_monterey: "1c7a7122f5b75d0a5506b3c9bc00906a10ed3b9f1ce134d1f75b78ac623c49fa"
    sha256                               arm64_big_sur:  "2208ad980a7e8d57dc2ba7ccdb9c68b540d24701ebde8d6202f0597231ce7ca2"
    sha256 cellar: :any_skip_relocation, ventura:        "0d15cc67f39f4959d9dacbac2c7110d47b3e83878ad270b941fdceebcd908e73"
    sha256 cellar: :any_skip_relocation, monterey:       "0d15cc67f39f4959d9dacbac2c7110d47b3e83878ad270b941fdceebcd908e73"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d15cc67f39f4959d9dacbac2c7110d47b3e83878ad270b941fdceebcd908e73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "290039fc58d8efa5510366fd62a1feb93d1b406cce24c1a5931a3eb0ad73f71d"
  end

  depends_on "node"

  uses_from_macos "expect" => :test
  on_macos do
    depends_on "macos-term-size"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    term_size_vendor_dir = libexec/"lib/node_modules/firebase-tools/node_modules/term-size/vendor"
    term_size_vendor_dir.rmtree # remove pre-built binaries

    if OS.mac?
      macos_dir = term_size_vendor_dir/"macos"
      macos_dir.mkpath
      # Replace the vendored pre-built term-size with one we build ourselves
      ln_sf (Formula["macos-term-size"].opt_bin/"term-size").relative_path_from(macos_dir), macos_dir
    end
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/firebase login:ci --no-localhost
      expect "Paste"
    EOS
    assert_match "authorization code", shell_output("expect -f test.exp")
  end
end
