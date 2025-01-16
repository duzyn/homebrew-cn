class Uv < Formula
  desc "Extremely fast Python package installer and resolver, written in Rust"
  homepage "https://github.com/astral-sh/uv"
  url "https://mirror.ghproxy.com/https://github.com/astral-sh/uv/archive/refs/tags/0.5.19.tar.gz"
  sha256 "4d9cccc48fb54b88bfe43f8eddd8d027b11337de58aa3f7c15428da7ddab5903"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/astral-sh/uv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "716f930a3dc57dc7ca48722c6a98398a8209e47fa3371fbd443ff3eb3f37dc59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e607bbe581a80b04bff64285c6fd6a67887c0acba8a8588a9371ad1d28e288a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "44736b4cd7fcf68a73553045a6640e277e3e444fdba72af145bccbe0de09f41e"
    sha256 cellar: :any_skip_relocation, sonoma:        "59b77509141896fb4bce8d45582635637db3296befe35b6cdf2f0338244a7460"
    sha256 cellar: :any_skip_relocation, ventura:       "60e572d91ca1267759128a9a5d19ced9632aa803d05d8f440fdad02eea2c2d32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a66023c77ce928392354d4dd9d93c83ba03726677fcd75f3ee6e373a04f272d"
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
