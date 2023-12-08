class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://mirror.ghproxy.com/https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "17fc3b79e3667a81432fe6128072dbed41e252b3116a1ead6a20792a776062c7"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9d1e0b21a21edd6b4618235e9cbe21114c5dec76c17b9196cb7122b22bbb662f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6cf5172b1a23a8d452af79037780e390baa04a3f7d20d71b51ca32fe11882abb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e41ca035fc3590d99229605fbf9a5752ba3c6be2c6976eead2ef07fe56fa865e"
    sha256 cellar: :any_skip_relocation, sonoma:         "70f67ef3a8e1ea713a8f576e0ea3c05b4d79f70f370202d1114008bba9fa43a8"
    sha256 cellar: :any_skip_relocation, ventura:        "a7c4488ca609e603cd9fc0b672fe56f45877cf722f4144a30fdb96dec136aa26"
    sha256 cellar: :any_skip_relocation, monterey:       "fc4e35ea524f55541532bb34ef58aca29b3dcc09fd11347fb1e66b1d01f400db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd58f8645976a48203b2b7bc1b953bc0331e4640678b473c6c94748cdcf2e0e7"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/relayproxy"
  end

  test do
    port = free_port

    (testpath/"flags.yml").write <<~EOS
      test-flag:
        variations:
          true-var: true
          false-var: false
        defaultRule:
          variation: true-var
    EOS

    (testpath/"test.yml").write <<~EOS
      listen: #{port}
      pollingInterval: 1000
      retriever:
        kind: file
        path: #{testpath}/flags.yml
    EOS

    begin
      pid = fork do
        exec bin/"go-feature-flag-relay-proxy", "--config", "#{testpath}/test.yml"
      end
      sleep 3

      expected_output = /true/

      assert_match expected_output, shell_output("curl -s http://localhost:#{port}/health")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
