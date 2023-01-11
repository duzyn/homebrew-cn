class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.6.0",
      revision: "561a3e1839f1a50ce832e8e114de399b2bee2542"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b9cfe8f32e72e9cd1e9f9a6cd971fe0577335b2f3ae59372bc28658a21efa73"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd2c1a1806a28044fb0a0634df6f2396b9a980de9b1b98b6b4660eac21970784"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c4b20c43ef19125e99d2bf9bbccd9f95c6534b7c72b80034762aead4eea28542"
    sha256 cellar: :any_skip_relocation, ventura:        "3dab5caf8f6381707ef4d5047a7fdb79ba31d8056aa20cfcf84a186bf68d0763"
    sha256 cellar: :any_skip_relocation, monterey:       "0ebdfe9060a9e4c73b3ac4720c05d9d80c9e4705a29c6e14a2a5438acb857ec0"
    sha256 cellar: :any_skip_relocation, big_sur:        "4152d3236db33dc2b57fb6b6ef68856e6bf38fd1aad4f3b7cc6f5da8a98f5b94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5996a97d35d433b59b012d0cf4e9cd6a0557e2fadc14416443492e6f6a390202"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "python@3.11" => :build

  uses_from_macos "libpcap"

  def install
    # remove non open source files
    rm_rf "x-pack"

    cd "packetbeat" do
      # prevent downloading binary wheels during python setup
      system "make", "PIP_INSTALL_PARAMS=--no-binary :all", "python-env"
      system "mage", "-v", "build"
      ENV.deparallelize
      system "mage", "-v", "update"

      inreplace "packetbeat.yml", "packetbeat.interfaces.device: any", "packetbeat.interfaces.device: en0"

      (etc/"packetbeat").install Dir["packetbeat.*", "fields.yml"]
      (libexec/"bin").install "packetbeat"
      prefix.install "_meta/kibana"
    end

    (bin/"packetbeat").write <<~EOS
      #!/bin/sh
      exec #{libexec}/bin/packetbeat \
        --path.config #{etc}/packetbeat \
        --path.data #{var}/lib/packetbeat \
        --path.home #{prefix} \
        --path.logs #{var}/log/packetbeat \
        "$@"
    EOS

    chmod 0555, bin/"packetbeat" # generate_completions_from_executable fails otherwise
    generate_completions_from_executable(bin/"packetbeat", "completion", shells: [:bash, :zsh])
  end

  service do
    run opt_bin/"packetbeat"
  end

  test do
    eth = if OS.mac?
      "en"
    else
      "eth"
    end
    assert_match "0: #{eth}0", shell_output("#{bin}/packetbeat devices")
    assert_match version.to_s, shell_output("#{bin}/packetbeat version")
  end
end
