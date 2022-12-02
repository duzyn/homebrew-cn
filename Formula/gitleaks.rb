class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v8.15.2.tar.gz"
  sha256 "8a4b742ad4a0c7fd125b7293bc34bbb25a1b0f7db2e20a457146b1cbe4fa38e1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e194e4c078f6c75668dbdf64aaa8788f1bd564a528b2f704c44532855d97652"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "585485f5e588dc070de7a12625321169ff200b12ad53768bf9c36d1d170c5ea8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "97812257ff4b4dfcca2c680479affb4448858e9a838897479e31c4e7b6ab3693"
    sha256 cellar: :any_skip_relocation, ventura:        "691e4d9cc04c583937741b7cc870473d31f1e9caee9f4d28762d80c05569bf03"
    sha256 cellar: :any_skip_relocation, monterey:       "6ed135d1dbcd733f706c9b1465d0cfd7d0cb6f0dcb9453e3264a99a65e9f50b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "c494d6d595469512808516d7ed2778a482e1ef7ced461e1d4fc314d03a71b4a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c85689e193f6f6015ae66099dde4defcdac1a04811b52b2f6c3d67ef7d668b3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/zricethezav/gitleaks/v#{version.major}/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"gitleaks", "completion")
  end

  test do
    (testpath/"README").write "ghp_deadbeefdeadbeefdeadbeefdeadbeefdeadbeef"
    system "git", "init"
    system "git", "add", "README"
    system "git", "commit", "-m", "Initial commit"
    assert_match(/WRN\S* leaks found: [1-9]/, shell_output("#{bin}/gitleaks detect 2>&1", 1))
    assert_equal version.to_s, shell_output("#{bin}/gitleaks version").strip
  end
end
