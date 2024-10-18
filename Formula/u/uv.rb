class Uv < Formula
  desc "Extremely fast Python package installer and resolver, written in Rust"
  homepage "https://github.com/astral-sh/uv"
  url "https://mirror.ghproxy.com/https://github.com/astral-sh/uv/archive/refs/tags/0.4.23.tar.gz"
  sha256 "71ef48e37d548b9681488afda567eed309efcba4774d0afd19b8ea16be62a95b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/astral-sh/uv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d105434b0ca24d4660b56824fc4694fead12e4275c04b65bf0f8047885621e1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ebd49484a2a1ec2e6d390dbbd58688c875dfca8f7829b26670bac54edb9294af"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d461177125db5543d1fe790f90846c0805054dd0f7417d95f26e6669b854ffff"
    sha256 cellar: :any_skip_relocation, sonoma:        "f872c6970eaa502cde338c217a52f07a4639fc7f0bf64706f80ff25ec776e153"
    sha256 cellar: :any_skip_relocation, ventura:       "1e985fcc75dec893b0936d189e6063874f76b790d8891af4e73eabb4287258c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "187ac127dbc3f8e2cfa0482b03e41f8d92ac10e6c1652925244846cc265e75f2"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  uses_from_macos "python" => :test
  uses_from_macos "bzip2"
  uses_from_macos "xz"

  def install
    ENV["UV_COMMIT_HASH"] = ENV["UV_COMMIT_SHORT_HASH"] = tap.user
    ENV["UV_COMMIT_DATE"] = time.strftime("%F")
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/uv")
    generate_completions_from_executable(bin/"uv", "generate-shell-completion")
    generate_completions_from_executable(bin/"uvx", "--generate-shell-completion", base_name: "uvx")
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
