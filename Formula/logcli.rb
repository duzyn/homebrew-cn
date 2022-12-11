class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.7.1.tar.gz"
  sha256 "363f7ba0782e3eb1cfa89b1240311b182ce3e1c0c53497f18e876e71749f0e89"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c17c08d69bb343cbbc14ad3d1bca9b20cbeebf868a74158884e832f5d32a535"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f31ab4c5d7e70fec6f0483602b2e6bf356cbf43e06a16a1f1546568936087135"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "65c5556705f0da02601bb5ed39cb65ffd20033846c64d22cc1830bc11820fb93"
    sha256 cellar: :any_skip_relocation, ventura:        "ecc598b8c62649560950de5f926d52af535361d5c3de134df00c55a82e84686d"
    sha256 cellar: :any_skip_relocation, monterey:       "6d4b8059f1b2c3bda92fb22862b6f9935c8dcc687bdb03c5335cb95316e992f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "4638b9f160c090a597eb3d883192fee36b3b3bcfa36d6653175b53f6f018de9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2efcf510740a8f8f6487dfdb33d31e4e6c5ade49686a3fea13c879a7f582ad9d"
  end

  depends_on "go" => :build
  depends_on "loki" => :test

  resource "testdata" do
    url "https://ghproxy.com/raw.githubusercontent.com/grafana/loki/f5fd029660034d31833ff1d2620bb82d1c1618af/cmd/loki/loki-local-config.yaml"
    sha256 "27db56559262963688b6b1bf582c4dc76f82faf1fa5739dcf61a8a52425b7198"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/logcli"
  end

  test do
    port = free_port

    testpath.install resource("testdata")
    inreplace "loki-local-config.yaml" do |s|
      s.gsub! "3100", port.to_s
      s.gsub! "/tmp", testpath
    end

    fork { exec Formula["loki"].bin/"loki", "-config.file=loki-local-config.yaml" }
    sleep 3

    assert_empty shell_output("#{bin}/logcli --addr=http://localhost:#{port} labels")
  end
end
