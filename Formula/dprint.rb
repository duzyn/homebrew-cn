class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/0.34.1.tar.gz"
  sha256 "df67b9fcdfb1ad429737e321b2e6263e68301725948862df1b315f3cad8ede1f"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "910c89c28af367ae3c134b8f59162da8e14ba8bb92bed351ffa5cb5daedc0eb0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9be49e1c639fa0cef7adc00b7b9ddf529237d92ef0d5cb1e7496f2cacb05af05"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a085921d71e44238efed63ec18d041e7f2f80133fb3bbd8ad65cc88bc66cfdd"
    sha256 cellar: :any_skip_relocation, ventura:        "1d6461498940406376ea1374a133ff2a6066bb9c6c3ce3463092953c2306d9a4"
    sha256 cellar: :any_skip_relocation, monterey:       "87bb86e09f841a6f2f55f431f449ba25011c0bf7644559f86c9e9258f9435c53"
    sha256 cellar: :any_skip_relocation, big_sur:        "08d8de0c721b4bd95f65df0771778e7f0c6971ec287b5a0d705bc4c6def56d96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f6dec34e236f402bbf85150f1208810028da000448449718c5240c7fd0a3664"
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
