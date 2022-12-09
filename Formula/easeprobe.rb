class Easeprobe < Formula
  desc "Simple, standalone, and lightWeight tool that can do health/status checking"
  homepage "https://github.com/megaease/easeprobe"
  url "https://github.com/megaease/easeprobe.git",
      tag:      "v2.0.0",
      revision: "9a75ba2a674941c6c8a369f503177dfb4fbee209"
  license "Apache-2.0"
  head "https://github.com/megaease/easeprobe.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ddee35149153035ef898ff143c661f53f5ed6488d90dc0de6e51fc72ef639db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1887105ef3b5ed78fd4f5f2036a9767bab1d17a617c7271203caff127641a48"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ea35471efe485bc4d89518c3a762793f6059b3de35c637446e8b19f86808e0cd"
    sha256 cellar: :any_skip_relocation, ventura:        "406e69803404a9cc29bfe3b01a0e143cdd3bf36e47e27d5fa5ac60faa5740e80"
    sha256 cellar: :any_skip_relocation, monterey:       "861384bd669d6e44e91015e4a02fa752df95a9f48e80556141c3350e4b5ae57a"
    sha256 cellar: :any_skip_relocation, big_sur:        "f1d2462d5e9fd7102c9e6cab490f2862ec524ca0372ae1478543bcd2fa9998f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77387f14ead50fc776abedb87b3b5d236aabf25367bdd84a800397cfa0dda0b1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/megaease/easeprobe/pkg/version.RELEASE=#{version}
      -X github.com/megaease/easeprobe/pkg/version.COMMIT=#{Utils.git_head}
      -X github.com/megaease/easeprobe/pkg/version.REPO=megaease/easeprobe
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/easeprobe"
  end

  test do
    (testpath/"config.yml").write <<~EOS.chomp
      http:
        - name: "brew.sh"
          url: "https://brew.sh"
      notify:
        log:
          - name: "logfile"
            file: #{testpath}/easeprobe.log
    EOS

    easeprobe_stdout = (testpath/"easeprobe.log")

    pid = fork do
      $stdout.reopen(easeprobe_stdout)
      exec bin/"easeprobe", "-f", testpath/"config.yml"
    end
    sleep 2
    assert_match "Ready to monitor(http): brew.sh", easeprobe_stdout.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
