class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-21.3.8.tgz"
  sha256 "4db48bbbc0ae035e56d168f0c8db7a064a69e56542f43a81a9ec3cdd3e74460c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a1e1ba01f4d865a65490167de5694d7065c36e8b1cbc8dc6838cecccf06637db"
    sha256 cellar: :any,                 arm64_sonoma:  "a1e1ba01f4d865a65490167de5694d7065c36e8b1cbc8dc6838cecccf06637db"
    sha256 cellar: :any,                 arm64_ventura: "a1e1ba01f4d865a65490167de5694d7065c36e8b1cbc8dc6838cecccf06637db"
    sha256 cellar: :any,                 sonoma:        "1c3f6294d0395071a6d7baf6b702df6cf48a52016438969a7dc7242293bc91e4"
    sha256 cellar: :any,                 ventura:       "1c3f6294d0395071a6d7baf6b702df6cf48a52016438969a7dc7242293bc91e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "370b3727447e580452da90ddd6c22f8179fa77e25477af62ce43ca2a67e1f9cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9558cd18ea1c16b2b4ef949d98f16c17c03b8fbd6ac6a29df3c2267a05d71d90"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"package.json").write <<~JSON
      {
        "name": "@acme/repo",
        "version": "0.0.1",
        "scripts": {
          "test": "echo 'Tests passed'"
        }
      }
    JSON

    system bin/"nx", "init", "--no-interactive"
    assert_path_exists testpath/"nx.json"

    output = shell_output("#{bin}/nx 'test'")
    assert_match "Successfully ran target test", output
  end
end
