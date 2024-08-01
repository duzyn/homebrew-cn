class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://mirror.ghproxy.com/https://github.com/cloudflare/cloudflared/archive/refs/tags/2024.7.2.tar.gz"
  sha256 "0fee62f419989cef484ddc71dc86b581633be3acd7f04a4f985af7a7645bc8fa"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c8814ef343a90cd4004f9c5af43fbcf01b0c28031cfead337c246ad246c5d70b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e5a3e7f16d8e955364e8ddafe9c94cdeac6ab42448fc37617fed3e4e8710c0a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9d2846f34a8d7837ca2d934a15c522015c7646cb7d04a5feea16595061d2517"
    sha256 cellar: :any_skip_relocation, sonoma:         "6d74e6d8d0659f404902a762a3cb767197853ec073772e515f85dc9361365f80"
    sha256 cellar: :any_skip_relocation, ventura:        "06f5d34622d58d1c878f2d4b808b5dbdf74af72a40ac562a20005cc7b6a96aea"
    sha256 cellar: :any_skip_relocation, monterey:       "8c1cf850f72831ce15e5b3d6a66d38573050ab42c299b964f11a2e045f440e50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae2a85772766d9ef21525a6bf3c6b0b06e1dd942cf30d71633c09eeb5aae13be"
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
