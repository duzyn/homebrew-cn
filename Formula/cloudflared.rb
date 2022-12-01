class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2022.11.1.tar.gz"
  sha256 "d4b1133057a721087a0a5387ea6d4d1ebf3b1f5135396da25a1e88e873cd5203"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be2a477af71afadd1994b3637b4d6461eb16f69e17e78b0a40de3060da776469"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "763907eb6b08f19378ca5d78bf7f887d2cd08a95d47879f2fcfdd8268f41c990"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "292ec94992f162450b7a32a96c309887d05fbbd27dbbbb8cb3499700ae28f834"
    sha256 cellar: :any_skip_relocation, ventura:        "b6c976a0b51bc028a92c7bfdd85dc9cb4f0f09947f98348f7730fc220732bc99"
    sha256 cellar: :any_skip_relocation, monterey:       "f85079f21befb79c883f0821f0a9c5ab8c53fc7f40f50c14ca6ad293052dc667"
    sha256 cellar: :any_skip_relocation, big_sur:        "1da9ddf535525c4ab895a339934485be93507fe71ce1112e78a4482edab74b90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f67c75a4e26401d3c7dcac5f48dfad6fd281dc7de13c0dea2e7bcef3a910eb1"
  end

  depends_on "go" => :build

  def install
    system "make", "install",
      "VERSION=#{version}",
      "DATE=#{time.iso8601}",
      "PACKAGE_MANAGER=#{tap.user}",
      "PREFIX=#{prefix}"
  end

  test do
    help_output = shell_output("#{bin}/cloudflared help")
    assert_match "cloudflared - Cloudflare's command-line tool and agent", help_output
    assert_match version.to_s, help_output
    assert_equal "unable to find config file\n", shell_output("#{bin}/cloudflared 2>&1", 1)
    assert_match "Error locating origin cert", shell_output("#{bin}/cloudflared tunnel run abcd 2>&1", 1)
    assert_match "cloudflared was installed by #{tap.user}. Please update using the same method.",
      shell_output("#{bin}/cloudflared update 2>&1")
  end
end
