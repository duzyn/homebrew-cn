class Uv < Formula
  desc "Extremely fast Python package installer and resolver, written in Rust"
  homepage "https://github.com/astral-sh/uv"
  url "https://mirror.ghproxy.com/https://github.com/astral-sh/uv/archive/refs/tags/0.2.10.tar.gz"
  sha256 "9be4dcb55e94084b7a0fa4a07bafc33d10f679c104632a80f9e7ab9b31ae784f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/astral-sh/uv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c5e38f0234701afdd2258876c81b50f9119bb6ffca689689ab0efa6aa7634001"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ef110e50df92ab6445658c5e6b4523bc7e637e34a3d5ae6c20d84b93bd7f741"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32943a7a2891f38cc0bd505bbb08f6e6dcf4316b2e4321fbd832e1f94aae3d29"
    sha256 cellar: :any_skip_relocation, sonoma:         "9c3ff4949e8b1038335a2e2342af2ede8dec51281229dbd9910bde79ab80e022"
    sha256 cellar: :any_skip_relocation, ventura:        "5618620df9982bbc23e8ba7ee922808d690f5b3bd719db2c96819bf0bbe04678"
    sha256 cellar: :any_skip_relocation, monterey:       "bf8b53cbe3c23c199b3c46eea09535b8b05e422a904b871c6e321e9fc082c746"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a20b2d16b9a81b2d3634d3db6c0564261fc99de1c2e30cc693034647316a3e0"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  uses_from_macos "python" => :test

  on_linux do
    # On macOS, bzip2-sys will use the bundled lib as it cannot find the system or brew lib.
    # We only ship bzip2.pc on Linux which bzip2-sys needs to find library.
    depends_on "bzip2"
  end

  def install
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
  end
end
