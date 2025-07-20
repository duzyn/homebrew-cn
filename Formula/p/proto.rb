class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://mirror.ghproxy.com/https://github.com/moonrepo/proto/archive/refs/tags/v0.51.2.tar.gz"
  sha256 "c23dc2b8b20ea268220d03827f34434a80d620b98974d316a446af1254ae7baf"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e103b445057fb784e4e6d025bb18a50a36ca924a6e0b37362dbd34c7cf608709"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92747553aa24817d6799450f0f2ac66bac1d12b79bf47cc42783bdbac8f2b9cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cc7a3fd9887ce8cf70932fd52dc5637a4aed1d24f1352328b76bad93d43012a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b40c0b21586c36ec39ee672f6aec8e8f03da9bbc2bd376d25461d84cdbab425"
    sha256 cellar: :any_skip_relocation, ventura:       "98365aa30e0504b454a38c582f2c1d40715ff54fa855df1481a7519cfb1bc5d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c376301f53367e147d8cdc0807440afc444567781457af7250c4630ebda90fe5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba1a57ff4bf1cc9de3af06c5a016c75c28a077826efc583f98e94594703cb2c2"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
    depends_on "xz"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
    generate_completions_from_executable(bin/"proto", "completions", "--shell")

    bin.each_child do |f|
      basename = f.basename

      # shimming proto-shim would break any shims proto itself creates,
      # it luckily works fine without PROTO_LOOKUP_DIR
      next if basename.to_s == "proto-shim"

      (libexec/"bin").install f
      # PROTO_LOOKUP_DIR is necessary for proto to find its proto-shim binary
      (bin/basename).write_env_script libexec/"bin"/basename, PROTO_LOOKUP_DIR: opt_prefix/"bin"
    end
  end

  def caveats
    <<~EOS
      To finish the installation, run:
        proto setup
    EOS
  end

  test do
    system bin/"proto", "install", "node", "19.0.1"
    node = shell_output("#{bin}/proto bin node").chomp
    assert_match "19.0.1", shell_output("#{node} --version")

    path = testpath/"test.js"
    path.write "console.log('hello');"
    output = shell_output("#{testpath}/.proto/shims/node #{path}").strip
    assert_equal "hello", output
  end
end
