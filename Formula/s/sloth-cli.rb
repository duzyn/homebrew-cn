class SlothCli < Formula
  desc "Prometheus SLO generator"
  homepage "https://sloth.dev/"
  url "https://mirror.ghproxy.com/https://github.com/slok/sloth/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "783689544f1829cb139ab3bbdd5e53cc835469a92c4a187384ff51f08eceb284"
  license "Apache-2.0"
  head "https://github.com/slok/sloth.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1c990842a4c39840e5f0240f27d9da5157d7d8bc016f3391f52b3b6766bafcd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "170c93b4b71a8f35fc9ed555f4a04144978de36f33e591ce6f54826ec6ebc735"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a277f241361a71ab209b262a8e1398153f01dee27aa516d74964e60e58b0b065"
    sha256 cellar: :any_skip_relocation, sonoma:        "b59a01ec305744639a17c93f970bf0cdbdd46911762ff76a0df40bc5bcf41873"
    sha256 cellar: :any_skip_relocation, ventura:       "eac5fbb9da7a44730c8dfff467cfec9f4ea0e3c14ddd6c6eb7460ccdc148a0e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08c465be42d6e6b202aed56db3778072d4650aae2e78ac5aee752c6db0e1ea5b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/slok/sloth/internal/info.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"sloth", ldflags:), "./cmd/sloth"

    pkgshare.install "examples"
  end

  test do
    test_file = pkgshare/"examples/getting-started.yml"

    output = shell_output("#{bin}/sloth validate -i #{test_file} 2>&1")
    assert_match "Validation succeeded", output

    output = shell_output("#{bin}/sloth generate -i #{test_file} 2>&1")
    assert_match "SLO alert rules generated", output
    assert_match "Code generated by Sloth", output

    assert_match version.to_s, shell_output("#{bin}/sloth version")
  end
end
