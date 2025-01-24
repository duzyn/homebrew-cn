class Uv < Formula
  desc "Extremely fast Python package installer and resolver, written in Rust"
  homepage "https://github.com/astral-sh/uv"
  url "https://mirror.ghproxy.com/https://github.com/astral-sh/uv/archive/refs/tags/0.5.23.tar.gz"
  sha256 "a8b042e9b600ba0b6058b733f548061f652925982bd0892120c8d48923bc1bb2"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/astral-sh/uv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a91437fd78a717faca11720acd2799a977fa61924ba38284cae88ca24bd40707"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "744952936dafb5a94453261c191bfe84a82458d057cf3f6a74c332a1d0734d3b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "25f41fc64cd7d60e172d5c61892747f177d2298b1514c947de0da03901ade864"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7be049922afa6e2af330d603e5b3311080083b1b72e53e81683fa01572bdfc8"
    sha256 cellar: :any_skip_relocation, ventura:       "a42cbf0405fb39182d8ed86c5cfb5e3045c859520daa66f1506b16e1247465f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8463c0b31d4cd14b875f6b2120abccbf3fbdf97d0f7d1e1f0f964a35b1d8b606"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "python" => :test
  uses_from_macos "bzip2"
  uses_from_macos "xz"

  def install
    ENV["UV_COMMIT_HASH"] = ENV["UV_COMMIT_SHORT_HASH"] = tap.user
    ENV["UV_COMMIT_DATE"] = time.strftime("%F")
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/uv")
    generate_completions_from_executable(bin/"uv", "generate-shell-completion")
    generate_completions_from_executable(bin/"uvx", "--generate-shell-completion")
  end

  test do
    (testpath/"requirements.in").write <<~REQUIREMENTS
      requests
    REQUIREMENTS

    compiled = shell_output("#{bin}/uv pip compile -q requirements.in")
    assert_match "This file was autogenerated by uv", compiled
    assert_match "# via requests", compiled

    assert_match "ruff 0.5.1", shell_output("#{bin}/uvx -q ruff@0.5.1 --version")
  end
end
