class Uv < Formula
  desc "Extremely fast Python package installer and resolver, written in Rust"
  homepage "https://github.com/astral-sh/uv"
  url "https://mirror.ghproxy.com/https://github.com/astral-sh/uv/archive/refs/tags/0.4.14.tar.gz"
  sha256 "0bb499e1edbc89c87575fcb66fb0f2358cc9091c5dfd5e1f05de3864ba7141e9"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/astral-sh/uv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "678fb0c3a3d02e316401abd3ea2f67cfeaf153dd77345f0b6c12b16b06ede18b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9c963fac72aec3e439f8045c02e1c704963f2d06bd8b0d2ef3da35e274de49e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "792af3f1ce313e05e5ebc8f2c2127d05286552f641f1a725887d258bef6a1c61"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe1cf99eff02429f3fc5517b9f288ad1d2e3fa26d6962c657bc2fcbd4edd1369"
    sha256 cellar: :any_skip_relocation, ventura:       "c8eb94d00a9d88e6e3ce56e55c3b7fa5e6e51dd67b4141cced0c5946d024d0bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "badeac73d81bd01bda50149dc80b5f95a668ea323e15ae5bd7769970b93dbe57"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  uses_from_macos "python" => :test
  uses_from_macos "xz"

  on_linux do
    # On macOS, bzip2-sys will use the bundled lib as it cannot find the system or brew lib.
    # We only ship bzip2.pc on Linux which bzip2-sys needs to find library.
    depends_on "bzip2"
  end

  def install
    ENV["UV_COMMIT_HASH"] = ENV["UV_COMMIT_SHORT_HASH"] = tap.user
    ENV["UV_COMMIT_DATE"] = time.strftime("%F")
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/uv")
    generate_completions_from_executable(bin/"uv", "generate-shell-completion")
  end

  test do
    (testpath/"requirements.in").write <<~EOS
      requests
    EOS

    compiled = shell_output("#{bin}/uv pip compile -q requirements.in")
    assert_match "This file was autogenerated by uv", compiled
    assert_match "# via requests", compiled

    assert_match "ruff 0.5.1", shell_output("#{bin}/uvx -q ruff@0.5.1 --version")
  end
end
