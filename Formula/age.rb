class Age < Formula
  desc "Simple, modern, secure file encryption"
  homepage "https://github.com/FiloSottile/age"
  url "https://github.com/FiloSottile/age/archive/v1.1.0.tar.gz"
  sha256 "ad1ebd23094431799ba78301bcd71633e19b519c6ba14902d665d615d6b31fea"
  license "BSD-3-Clause"
  head "https://github.com/FiloSottile/age.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff3a5b5cabd377566b6e99b76e38345a0f8ca6ffc3ecf8ddcb7f3d314cd495a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab06b3f4e0b4a8447abf4be3947bd8e5831600d968ca7fa45a22748006e13339"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b84fd5d4f3ee80829eab7c83aa880b0a1aee343714c9004200a1a24736d72f2"
    sha256 cellar: :any_skip_relocation, ventura:        "276e60a99b88a5415192a4926646be841a6b4666e00db15ebfadc5c12d7d407b"
    sha256 cellar: :any_skip_relocation, monterey:       "e9bf688ac86ff5b0c381edc24b2b7b62b74e9430d2dfb6edb0cc6185cf807a2a"
    sha256 cellar: :any_skip_relocation, big_sur:        "ac89f70b7c5675c80eb5481d1411337bcc49cccf95fcbf44df78945a46b74a24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ae08f76442ce87213c7577f3bd3088161312df8a3c642a39df41a635b916140"
  end

  depends_on "go" => :build

  def install
    bin.mkpath
    system "go", "build", *std_go_args(ldflags: "-X main.Version=v#{version}"), "-o", bin, "filippo.io/age/cmd/..."
    man1.install "doc/age.1"
    man1.install "doc/age-keygen.1"
  end

  test do
    system bin/"age-keygen", "-o", "key.txt"
    pipe_output("#{bin}/age -e -i key.txt -o test.age", "test")
    assert_equal "test", shell_output("#{bin}/age -d -i key.txt test.age")
  end
end
