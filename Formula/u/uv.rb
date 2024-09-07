class Uv < Formula
  desc "Extremely fast Python package installer and resolver, written in Rust"
  homepage "https://github.com/astral-sh/uv"
  url "https://mirror.ghproxy.com/https://github.com/astral-sh/uv/archive/refs/tags/0.4.6.tar.gz"
  sha256 "d89a43e32851bd5df7c6c78d77718a68b75b61dccebee76efb717ae9c3349f63"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/astral-sh/uv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3432ea1281428eb20f52aa47d021b7da42a6401238f962b4eb043a9b461b87b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "144070cd95db0252cddb22fb1fc7f9d0bb11a6f0669569c6c0c5e4a0422aabdc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09fd7c37a51f2844c7b8142b94313a63c3e89232ec1a042d3619918df306b137"
    sha256 cellar: :any_skip_relocation, sonoma:         "84dbf851518bf5e7e9ddc4700859a0443d2c9b594a22405bf045c34502c4ca03"
    sha256 cellar: :any_skip_relocation, ventura:        "de45688178d174ec77d59e103a0f94796a994bb5a7607554fbb04566e42e7f33"
    sha256 cellar: :any_skip_relocation, monterey:       "6f2c31b58864112fb6f7977bf79c799efe3f1837393a543fa556457fd18239da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "402663bc3a4d0a7cd8a96dc83cec6395436bc82e76aaeb2ac1326b9e31020743"
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
