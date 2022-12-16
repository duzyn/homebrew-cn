class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.36.0",
      revision: "3a0f7f089f529e0ce2f29785735b05b30e730d2b"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "979f04e051e60832d9a9c340cd75c2076db9953ff226dfd5116f1f268f22ef90"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80c103918fb4dff17d18872a69f301632d067ee0a8b1e270fc59b92b7b97fa37"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc726827017da470444badb495fabc8de532ef3dddb0fe8e44ac4e5c48d17c6a"
    sha256 cellar: :any_skip_relocation, ventura:        "0fd7744c5111e6086ef310810b638a48ff3a57617702a9a30930036d8c98c157"
    sha256 cellar: :any_skip_relocation, monterey:       "794169f583930e3e48140a7840afdadc013cbaf862e2e5d8c8e238cd71cfe6e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "346ede5ddc5102f51c495805cbe24337b0030dd4ef20b17b2e354a0a7572b13c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7e57e6c69730ea6174657814c18514599e80b9c588feb2c12ea5d33f9f74f2a"
  end

  depends_on "go" => :build

  def install
    goarch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    os = OS.kernel_name.downcase
    ENV["VERSION"] = version.to_s
    ENV["GOOS"] = os
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ENV["GOARCH"] = goarch

    system "make", "dist-for-os"
    bin.install "dist/#{os}-newrelic-infra_#{os}_#{goarch}/newrelic-infra"
    bin.install "dist/#{os}-newrelic-infra-ctl_#{os}_#{goarch}/newrelic-infra-ctl"
    bin.install "dist/#{os}-newrelic-infra-service_#{os}_#{goarch}/newrelic-infra-service"
    (var/"db/newrelic-infra").install "assets/licence/LICENSE.macos.txt" if OS.mac?
  end

  def post_install
    (etc/"newrelic-infra").mkpath
    (var/"log/newrelic-infra").mkpath
  end

  service do
    run [bin/"newrelic-infra-service", "-config", etc/"newrelic-infra/newrelic-infra.yml"]
    log_path var/"log/newrelic-infra/newrelic-infra.log"
    error_log_path var/"log/newrelic-infra/newrelic-infra.stderr.log"
  end

  test do
    output = shell_output("#{bin}/newrelic-infra -validate")
    assert_match "config validation", output
  end
end
