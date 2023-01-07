class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  url "https://github.com/ariga/atlas/archive/v0.9.0.tar.gz"
  sha256 "0812ab01ee77b635609301fd6fd10c2c6cf00d22e5dff2325c39ef4cee961d8b"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6d48a664bb0f5efa5b1351f24f035b66753b35efb780597fef2a356680fda7a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d820ac5253644df9876cce384238c8608f93e2763a8ffb7d6b9520c1ad27db2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0c3b381ff3ab6b7f570a889929565cc28f3822d9260cc70bd8b85acbd583aca1"
    sha256 cellar: :any_skip_relocation, ventura:        "de91b827452dd8d3ae097b8e1328f7fbea23edd3d0c1f9cf25f1ff7210b9c35e"
    sha256 cellar: :any_skip_relocation, monterey:       "5a5f175837b523ac3d36cabc5c43d79299887ce1133f5939863c7b399acd41e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "a017ab31385424249911b5eccb8081e488bf6c01df624b7dad18680f215fd42f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "352e47d20a8550e8b60613d49dec618313a6e74df09ea208a47a0db81b0a5df4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X ariga.io/atlas/cmd/atlas/internal/cmdapi.version=v#{version}
    ]
    cd "./cmd/atlas" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    generate_completions_from_executable(bin/"atlas", "completion")
  end

  test do
    assert_match "Error: mysql: query system variables:",
      shell_output("#{bin}/atlas schema inspect -u \"mysql://user:pass@localhost:3306/dbname\" 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/atlas version")
  end
end
