class Pixi < Formula
  desc "Package management made easy"
  homepage "https://prefix.dev/docs/pixi/overview"
  url "https://mirror.ghproxy.com/https://github.com/prefix-dev/pixi/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "52c7f17e17a70dc72396b389bc4e7dbe0de43e1a5f9bb2f4f431ebec17b3b0fc"
  license "BSD-3-Clause"
  head "https://github.com/prefix-dev/pixi.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4b15cc7d8ec8031c73ab6568d23d41a6f57e5939a9b88ec1173fb03de1572fbb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f5fae148b5b834093800f8cdb79759fd526202ad210ec1f0051ccb5dad6fb88d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe6208e2f15d7340ff92f45dc0d0125309619039f9c5851724dd3a92425f13c5"
    sha256 cellar: :any_skip_relocation, sonoma:         "99424173c4a39b4c0ab4c7246c85555f4623521c9a41b09cd9d4157b6f4d398a"
    sha256 cellar: :any_skip_relocation, ventura:        "a1856993135007268fad62b28065e3c4418b96cb755691dacc96d6cc23995427"
    sha256 cellar: :any_skip_relocation, monterey:       "dba18e3edf7c936786a65cf9a7c4642d94eceeb9d14b69b95f11cdd9f06bde02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5b45d1a3660792ba3c654260162ad3452c4bca515bc25b34f4f4eef3ea82129"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"pixi", "completion", "-s")
  end

  test do
    assert_equal "pixi #{version}", shell_output("#{bin}/pixi --version").strip
    system "#{bin}/pixi", "init"
    assert_path_exists testpath/"pixi.toml"
  end
end
