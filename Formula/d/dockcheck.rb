class Dockcheck < Formula
  desc "CLI tool to automate docker image updates"
  homepage "https://github.com/mag37/dockcheck"
  url "https://mirror.ghproxy.com/https://github.com/mag37/dockcheck/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "624465cd2834a977a23e143dfa2059af563d1d44ed989e77ce3308aff2605e20"
  license "GPL-3.0-only"
  head "https://github.com/mag37/dockcheck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "32d83ba49b9b3bd02c0101e380c41e374bd0ef36b794e7691f2ed6c4bdf93246"
  end

  depends_on "jq"
  depends_on "regclient"

  def install
    bin.install "dockcheck.sh" => "dockcheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockcheck -v")

    output = shell_output("#{bin}/dockcheck 2>&1", 1)
    assert_match "No docker binaries available", output
  end
end
