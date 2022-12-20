class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/0.34.0.tar.gz"
  sha256 "6029e07daa0beae07bb5cff55576b4f16160736c721bea0194248a0aaa5b62c0"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "292f422c6dd7a316e3dcebf02a82f53f59d23aee625e1bac17b68efc861ebf51"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f767f5b999e4fb15686356971a897dba3388059707bfdad759c286ac0593587"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c3d05a6eedf440adad622800759009a40248c4a69b4872521e537d22968d299"
    sha256 cellar: :any_skip_relocation, ventura:        "42781c5cdb64e7f4f5c9b3da8020cee7dd370ffc9e981a412eac802276babd68"
    sha256 cellar: :any_skip_relocation, monterey:       "9980851f2383be70b3c5a5c08f07961bb77ded6152b2b78c65313f96fa8547db"
    sha256 cellar: :any_skip_relocation, big_sur:        "3835adfffb403bc28e059c62854db906586cac2e24cc08e5a9a00532fc7bca8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9927f982fa6d84acba4991b3b39ae849a993fc1b861adc6f62bc81b89a7ab0dd"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/dprint")
  end

  test do
    (testpath/"dprint.json").write <<~EOS
      {
        "$schema": "https://dprint.dev/schemas/v0.json",
        "projectType": "openSource",
        "incremental": true,
        "typescript": {
        },
        "json": {
        },
        "markdown": {
        },
        "rustfmt": {
        },
        "includes": ["**/*.{ts,tsx,js,jsx,json,md,rs}"],
        "excludes": [
          "**/node_modules",
          "**/*-lock.json",
          "**/target"
        ],
        "plugins": [
          "https://plugins.dprint.dev/typescript-0.44.1.wasm",
          "https://plugins.dprint.dev/json-0.7.2.wasm",
          "https://plugins.dprint.dev/markdown-0.4.3.wasm",
          "https://plugins.dprint.dev/rustfmt-0.3.0.wasm"
        ]
      }
    EOS

    (testpath/"test.js").write("const arr = [1,2];")
    system bin/"dprint", "fmt", testpath/"test.js"
    assert_match "const arr = [1, 2];", File.read(testpath/"test.js")

    assert_match "dprint #{version}", shell_output("#{bin}/dprint --version")
  end
end
