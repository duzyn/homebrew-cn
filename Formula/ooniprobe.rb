class Ooniprobe < Formula
  desc "Network interference detection tool"
  homepage "https://ooni.org/"
  url "https://github.com/ooni/probe-cli/archive/v3.16.7.tar.gz"
  sha256 "a019fd9e6f35a3dd4520b7d63d109e236b27121b835d901d6a7fbe12d608b070"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02d9e088beb99f91c8a0e2c38272bb82d648b63af467c745104229ac9e483d21"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22ef037a15f6a841f1f70eeca34a810b55a49ded1554c6966948cd6cc6db8b55"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8066a81a3c627d576f440d2964e2cebf565daa3a0cde04078ae58572ceef5b26"
    sha256 cellar: :any_skip_relocation, ventura:        "0cb6d743a1af9fced7be384db34f0d52c8c85dec54da4f7372f19363bdb70554"
    sha256 cellar: :any_skip_relocation, monterey:       "46e38c6c115c1b200601ecbb6b65a8d22914eda2e9f6308f3a10892b342bac39"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f251667b9758bdcb4497c4611d39c99e5abc90d163f132ef7e314d72e492b32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2070c9d8c9454ab033107f7a54776d97ff7bc63695312081a777ec11b4794eb"
  end

  depends_on "go" => :build
  depends_on "tor"

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w", "./cmd/ooniprobe"
    (var/"ooniprobe").mkpath
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ooniprobe version")
    # failed to sufficiently increase receive buffer size (was: 208 kiB, wanted: 2048 kiB, got: 416 kiB).
    return if OS.linux?

    (testpath/"config.json").write <<~EOS
      {
        "_version": 3,
        "_informed_consent": true,
        "sharing": {
          "include_ip": false,
          "include_asn": true,
          "upload_results": false
        },
        "nettests": {
          "websites_url_limit": 1,
          "websites_enabled_category_codes": []
        },
        "advanced": {
          "send_crash_reports": true,
          "collect_usage_stats": true
        }
      }
    EOS

    mkdir_p "#{testpath}/ooni_home"
    ENV["OONI_HOME"] = "#{testpath}/ooni_home"
    Open3.popen3(bin/"ooniprobe", "--config", testpath/"config.json", "run", "websites", "--batch") do |_, _, stderr|
      stderr.to_a.each do |line|
        j_line = JSON.parse(line)
        assert_equal j_line["level"], "info"
      end
    end
  end
end
