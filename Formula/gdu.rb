class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/v5.21.0.tar.gz"
  sha256 "46baf7b717312a54346d0040c82be922271345ddca14ebaf5704b05b2a46a325"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5657a0fae4c41d11993259783e7a427773532efb2a6547471f9b2978fa2f117"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ac68058d187b951cabcbe0a76e70815ae34e290793bd9b0cc09757fc7f7c1c6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0fd37be9e2c079d2b2716d28240db20e843a7831a3df3bd28cbbe2f8c7e4b10b"
    sha256 cellar: :any_skip_relocation, ventura:        "d784dc15f676237f3c60b83a3f835ca00497facd90dd55f248176d77b70032db"
    sha256 cellar: :any_skip_relocation, monterey:       "6cd557eca49448a60eea55b28490c20b067efc7b667653b15e3444d22c69cc5e"
    sha256 cellar: :any_skip_relocation, big_sur:        "03eec95ab8095a6f72031c8662c8ccbe92a6ea1877d085534ca74fdf42f47a96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24d54d200f2d0a0222f7beafc0cbc1b74b1cbc7b90cc4978796cace668763782"
  end

  depends_on "go" => :build

  conflicts_with "coreutils", because: "both install `gdu` binaries"

  def install
    user = Utils.safe_popen_read("id", "-u", "-n")
    major = version.major

    ldflags = %W[
      -s -w
      -X "github.com/dundee/gdu/v#{major}/build.Version=v#{version}"
      -X "github.com/dundee/gdu/v#{major}/build.Time=#{time}"
      -X "github.com/dundee/gdu/v#{major}/build.User=#{user}"
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/gdu"
  end

  test do
    mkdir_p testpath/"test_dir"
    (testpath/"test_dir"/"file1").write "hello"
    (testpath/"test_dir"/"file2").write "brew"

    assert_match version.to_s, shell_output("#{bin}/gdu -v")
    assert_match "colorized", shell_output("#{bin}/gdu --help 2>&1")
    assert_match "4.0 KiB file1", shell_output("#{bin}/gdu --non-interactive --no-progress #{testpath}/test_dir 2>&1")
  end
end
