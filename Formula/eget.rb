class Eget < Formula
  desc "Easily install prebuilt binaries from GitHub"
  homepage "https://github.com/zyedidia/eget"
  url "https://github.com/zyedidia/eget/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "50a54b10a2643b4086588ea06e9f6be210581c7bbad8aa4eca0e513212aaa7a0"
  license "MIT"
  head "https://github.com/zyedidia/eget.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c12b5e607e4d55fb6c65d895b32b22828d58f5b824b3c0a6e67998f989438312"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8cb94b85450d94bd30b303c05a3627a25f19b6827f315f68e18370d924c798b6"
    sha256 cellar: :any_skip_relocation, ventura:        "4853bd40ba4656ed3922dae58c31679666eca4bc5187581637570043aa76eb75"
    sha256 cellar: :any_skip_relocation, monterey:       "7e3d445c82f7e3974f1c302f74d9663250826bd082931580d8308e3c155c5d71"
    sha256 cellar: :any_skip_relocation, big_sur:        "a02c420db63e1a2103d15ae0b9df3037f5ec660dc79ea63701f3f959274dc353"
    sha256 cellar: :any_skip_relocation, catalina:       "32e90a815abd4608b66ab65eaeb7d02c48ada09dfa82105d50e020a8418c8a55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01774653ba4cfa6043211d1e8410e1c41ca75aff7d5d4f8cdbab4e40c301f7a5"
  end

  depends_on "go" => :build
  depends_on "pandoc" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
    system "make", "eget.1"
    man1.install "eget.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/eget -v")

    # Use eget to install a v1.1.0 release of itself,
    # and verify that the installed binary is functional.
    system bin/"eget", "zyedidia/eget",
                       "--tag", "v1.1.0",
                       "--to", testpath,
                       "--file", "eget"
    assert_match "eget version 1.1.0", shell_output("./eget -v")
  end
end
