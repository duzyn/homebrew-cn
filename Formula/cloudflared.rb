class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2022.12.1.tar.gz"
  sha256 "8cc5c41ea98a9d72687d5f62e733a9033191e834e4fa9b2aecc557f0ccfbda56"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b7f6d5c5b221e098195045fa401ffebe895866d5bec36fa4b0313d8d657576b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a3926c2ddd04706a9981740c3a74a314beb576cf9b43396c6bf83e8cb5f88e8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "22ae7d17cf539c0fffd763d38e6882c35ef8637afd20b00871f43c4c7313e7f5"
    sha256 cellar: :any_skip_relocation, ventura:        "fd2c308fcd428a6884d5bc62387ebb0533a1305b2e33b63317c729de3ce70ade"
    sha256 cellar: :any_skip_relocation, monterey:       "e8e3f44110565607ad7b8f198254e7e98555980bbb32727c1b60ea1dc7223597"
    sha256 cellar: :any_skip_relocation, big_sur:        "c35f672e288a79ae4b11abc1dad8b35329d2d3ea4ab6c754c37feb166c694bb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e0edac6d1e031862e54308f73afa53e12f8159e48571ac3ceeceb42f26604e0"
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
