class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman.git",
      tag:      "v3.16.0",
      revision: "c1dec137141cc4b1cc76bd46744941ba6370b1e0"
  license "MIT"
  head "https://github.com/Praqma/helmsman.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02bf69ad59ad20f71e590d7181aa15e99a2feaeb696eefd570a8deda0b242ac6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22483a4f32679f93489d3e1577c8b7ec1a3e7b3f4d23bfa83dd3a7b96f484a53"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f84e401a0b5aa76c4f210f3da7997998c068ea26829b80933b349bee35ffb106"
    sha256 cellar: :any_skip_relocation, ventura:        "cdcc3955883df2565f81841a4a71e207dcb066493bc256b074ea2fe2250d3c97"
    sha256 cellar: :any_skip_relocation, monterey:       "11a1e5b9e1e419b5606ff98526941399ab54cf3663f0996ba40e7cfa16448a13"
    sha256 cellar: :any_skip_relocation, big_sur:        "7186055abd47b5f74b42c4798ae5a31fa79242c81ade2d36ad83582cfa8ebf77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7dec06af7e7b779229fec2413e0ff7e1e4c5407735327a5e859183b2ee2ba63e"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/helmsman"
    pkgshare.install "examples/example.yaml"
    pkgshare.install "examples/job.yaml"
  end

  test do
    ENV["ORG_PATH"] = "brewtest"
    ENV["VALUE"] = "brewtest"

    output = shell_output("#{bin}/helmsman --apply -f #{pkgshare}/example.yaml 2>&1", 1)
    assert_match "helm diff not found", output

    assert_match version.to_s, shell_output("#{bin}/helmsman version")
  end
end
