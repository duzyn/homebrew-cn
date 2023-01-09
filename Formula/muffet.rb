class Muffet < Formula
  desc "Fast website link checker in Go"
  homepage "https://github.com/raviqqe/muffet"
  url "https://github.com/raviqqe/muffet/archive/v2.6.3.tar.gz"
  sha256 "8479b5d721d41e752bf7d59c0922aaed4a1ae928a31330b8c20ccf14c0f1037a"
  license "MIT"
  head "https://github.com/raviqqe/muffet.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe82c7afbc2708cf158dcec44267bec8340a7de511c5d0528df0655b4af89558"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5cda579881cb6262f600214d6f5f8be21c96c4dc8044328818e5b4806b6983d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7cfeed665f5c6ec73140aa78e5f9368ce375d08dce7885a25c744b376a2703c1"
    sha256 cellar: :any_skip_relocation, ventura:        "bc94885bf1bd396086be6d51ff43dfbc00ea813245cbf3d0155a53c2081887bd"
    sha256 cellar: :any_skip_relocation, monterey:       "37c0887dbad078f794a5813fb3b340435910c575d1a154ca7825e1e0d3a3c9ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "29eaba21a1d19d2edf563c39b364d76eb10c80a8e10e4916e876232a7bb0fa69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28b51ce5f7bd5f77ac50494999cadf91f10731b5c74d6d3a0bdf2e727ed8756d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match(/failed to fetch root page: lookup does\.not\.exist.*: no such host/,
                 shell_output("#{bin}/muffet https://does.not.exist 2>&1", 1))

    assert_match "https://httpbin.org/",
                 shell_output("#{bin}/muffet https://httpbin.org 2>&1", 1)
  end
end
