class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https://github.com/projectdiscovery/httpx"
  url "https://github.com/projectdiscovery/httpx/archive/v1.2.6.tar.gz"
  sha256 "9e23adb86879a20062c8921ce6125c80a8e20d6ceadcb72a9bd6403903e67085"
  license "MIT"
  head "https://github.com/projectdiscovery/httpx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "434813563cd40794667e797ab5ceacec837bf9c44387b847ffebeb309335e056"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7d297133e440f438a6bb334edd15267a72d77322be0a65eaf059cec50facdc7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "75dbf3822fc11855e04cb3bff33c26c26ba218133c829bbe071d888c2f659bbe"
    sha256 cellar: :any_skip_relocation, ventura:        "ecaf55d1ec7101738a43cd710a27a18e9fa1fb5d2c076010404629818696f90b"
    sha256 cellar: :any_skip_relocation, monterey:       "2c3dab525b47919077b8db751ef0a0a752adc714d5eced3debc90fe02edbf81d"
    sha256 cellar: :any_skip_relocation, big_sur:        "19e1560faa99a03622abfe080b193f502fc36bdf46d432af1761a5279e0a2a0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f1f051a26f02c5ba3afe99969468c1e8c1c7f613293882051322cff2c263ada"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/httpx"
  end

  test do
    output = JSON.parse(shell_output("#{bin}/httpx -silent -title -json -u example.org"))
    assert_equal 200, output["status_code"]
    assert_equal "Example Domain", output["title"]
  end
end
