class Uv < Formula
  desc "Extremely fast Python package installer and resolver, written in Rust"
  homepage "https://github.com/astral-sh/uv"
  url "https://mirror.ghproxy.com/https://github.com/astral-sh/uv/archive/refs/tags/0.3.2.tar.gz"
  sha256 "f81ecd38dbaad3664084549a7f2152b6042a1984e2cee3b0d5f90751a8dc9ad3"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/astral-sh/uv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0db1c422dc321a0237bc3283c34f4352a99e962e519ab60ba96a893a717d3e22"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4228f19bf34baadac0bbbf631e087b667721aa7cd53d2c7005abb73f16afe709"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ad80ee865b550fdc05b4543de0f4cd68fc8fd2279373c6193aae1c4e18405b0"
    sha256 cellar: :any_skip_relocation, sonoma:         "d2edba6a218b91ea5cea03448fc322286e03c4c4db82136fb23ea982a4a7afc5"
    sha256 cellar: :any_skip_relocation, ventura:        "89c86b95beba96f5d1041f2a41d84235c6e02f49b1c3874e0bd887d74c0e954a"
    sha256 cellar: :any_skip_relocation, monterey:       "7f8825c37db5a05480ffdeb14f8ce7109976c1fc1874ff1ba77bf7d84a8e6eb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1516dc7de62dd61bfbebdde087fdea108e981dcf1745ac8b294501b14c4cfdd9"
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
