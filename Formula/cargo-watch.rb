class CargoWatch < Formula
  desc "Watches over your Cargo project's source"
  homepage "https://watchexec.github.io/#cargo-watch"
  url "https://github.com/watchexec/cargo-watch/archive/v8.2.1.tar.gz"
  sha256 "70f8e6d7da016062aa085cc2d86b2467482249d0e4ea0610a54b556890e24153"
  license "CC0-1.0"
  head "https://github.com/watchexec/cargo-watch.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32ee47b0329c45b6f367d1ae31247e326dd8c6972582f5b794ad60c7a3339b09"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0504b6daec12229ab1d0abdcf57a029bc5bf94213b77e0e47a4636bc73cae573"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "19543ea7c8a1752069344ea2ab24f89a27dbe55152620287647d97ee25b4184e"
    sha256 cellar: :any_skip_relocation, ventura:        "aa332135b836d6e607a22180dfce8f538699db1c060e6b483f419ba63042c10c"
    sha256 cellar: :any_skip_relocation, monterey:       "ae38d5b854149ffa8b93a54004b65e1b5c40a61d2a7e6e3b9ad48dda714cae35"
    sha256 cellar: :any_skip_relocation, big_sur:        "d191c6b3eedc481deea38700da95c5affff8e6a3223c0971a77577afa2f82981"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92dc1c4a8b2888b7499effb00774057224c903dcc89fa318c6afce692b75a226"
  end

  depends_on "rust" => [:build, :test]

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/cargo-watch -x build 2>&1", 1)
    assert_match "error: project root does not exist", output

    assert_equal "cargo-watch #{version}", shell_output("#{bin}/cargo-watch --version").strip
  end
end
