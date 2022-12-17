class OsvScanner < Formula
  desc "Vulnerability scanner which uses the OSV database"
  homepage "https://github.com/google/osv-scanner"
  url "https://github.com/google/osv-scanner/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "894f2991e9fa8e1fb1a8f8605779826884e11a2d5e3616814549ef873e5598bd"
  license "Apache-2.0"
  head "https://github.com/google/osv-scanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3fa6c972ceca7371071177255245c69030f6fbe00807de23abc5e53d0074315"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db9bf7cf15e1029b56b527f691010bb8ddba4545273f6c3710318ac71710889a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f0a3f66a673237c36f07151a145f61f6ae9ac73b030d495a6f97304e90f3ddfd"
    sha256 cellar: :any_skip_relocation, ventura:        "0503e276293b0f0b93f685d10593eb179445dd9cdbc09ee234b3bb4972ff9f72"
    sha256 cellar: :any_skip_relocation, monterey:       "5362100427c8e67b5359831bf4170d8a1fededdb0e014a8134012373aaf63373"
    sha256 cellar: :any_skip_relocation, big_sur:        "f4b798ebf2de3935cbc8748bbda18feaf065ca9c4e01ac09c3fb900a305e5e17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71c0d179b6c9a8fae5ccb6d743c7ee491bd054d5134979ba4982f3bc177119fc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/osv-scanner"
  end

  test do
    (testpath/"go.mod").write <<~EOS
      module my-library

      require (
        github.com/BurntSushi/toml v1.0.0
      )
    EOS

    scan_output = shell_output("#{bin}/osv-scanner --lockfile #{testpath}/go.mod").strip
    assert_equal "Scanned #{testpath}/go.mod file and found 1 packages", scan_output
  end
end
