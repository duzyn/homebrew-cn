class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.34.1",
      revision: "331d553a5eb90401c071021bae5dd24ce3993500"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e274e440183529fc8394f4c2c4d12c54619918b1d4e6d5ce1f781be3e5d24aa2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a198eca5d3c48425bc521ce20028e1fcd12939098346f36df176b55ca403430"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "68a06e627709c93b921a351593bcc35fa87583c34ef0e320885d1ec0ceb701ae"
    sha256 cellar: :any_skip_relocation, ventura:        "7d5a73158e38a266c0b685ca3dc943874d0af3e78714dfc9e93c80f0669a78b9"
    sha256 cellar: :any_skip_relocation, monterey:       "f0e193cc3201cd996a87513e06017dd1c94442d3a8ee6f308e32c41a84c46e3c"
    sha256 cellar: :any_skip_relocation, big_sur:        "a202b7a7518fc5ca05c461bce0f017f801ff4d328163340c85fdd20094cd3490"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "465b70333d94eaa2a0c955649a7c477d4658524a573e9d82b3610bda207d4b89"
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
