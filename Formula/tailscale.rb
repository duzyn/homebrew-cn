class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.34.0",
      revision: "988801d5d97287a276fc74cddb09a0e0ddf8afb7"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d52f4d80251d3fde1170a645b4316df76f0131c70a1f54c3128b1bb3e7cd29f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "feb5f8baa04ce796d244d39a47fb031ed4f1af921f2fd6cf14d67a8fedd0ef72"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "daacab1b0f0840b6760dcbad075c73b858674a61b043e7004d78dd8c3c53aa96"
    sha256 cellar: :any_skip_relocation, ventura:        "806eb7263de0031fb289db3a695718471d31a2f658a2c225e18c962e26fae428"
    sha256 cellar: :any_skip_relocation, monterey:       "658c5091109ffa8e185f523576990f3195ddb439b158b8f2f64807d91076441a"
    sha256 cellar: :any_skip_relocation, big_sur:        "d4d2ed509a215fb2b5d8d010ae0ebc51f9309fb79911fb622b27146f8e7a3278"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72930fda08d49dbe3d46adb1a67d62d8fcb59afc76b102ff044df09b49c1ed89"
  end

  depends_on "go" => :build

  def install
    vars = Utils.safe_popen_read("./build_dist.sh", "shellvars")
    ldflags = %W[
      -s -w
      -X tailscale.com/version.Long=#{vars.match(/VERSION_LONG="(.*)"/)[1]}
      -X tailscale.com/version.Short=#{vars.match(/VERSION_SHORT="(.*)"/)[1]}
      -X tailscale.com/version.GitCommit=#{vars.match(/VERSION_GIT_HASH="(.*)-dirty"/)[1]}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags: ldflags), "tailscale.com/cmd/tailscale"
    system "go", "build", *std_go_args(ldflags: ldflags), "-o", bin/"tailscaled", "tailscale.com/cmd/tailscaled"
  end

  service do
    run opt_bin/"tailscaled"
    keep_alive true
    log_path var/"log/tailscaled.log"
    error_log_path var/"log/tailscaled.log"
  end

  test do
    version_text = shell_output("#{bin}/tailscale version")
    assert_match version.to_s, version_text
    assert_match(/commit: [a-f0-9]{40}/, version_text)

    fork do
      system bin/"tailscaled", "-tun=userspace-networking", "-socket=#{testpath}/tailscaled.socket"
    end

    sleep 2
    assert_match "Logged out.", shell_output("#{bin}/tailscale --socket=#{testpath}/tailscaled.socket status", 1)
  end
end
