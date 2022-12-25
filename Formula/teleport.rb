class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v11.1.4.tar.gz"
  sha256 "ce43c54c4cab98d332ef8001cf10b7d0bf4e37825255d9a391bada5864a56b0c"
  license "Apache-2.0"
  head "https://github.com/gravitational/teleport.git", branch: "master"

  # We check the Git tags instead of using the `GithubLatest` strategy, as the
  # "latest" version can be incorrect. As of writing, two major versions of
  # `teleport` are being maintained side by side and the "latest" tag can point
  # to a release from the older major version.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a93dd41c2af71d3799efbf2b024dc015102857668f15b447590d3b5079023614"
    sha256 cellar: :any,                 arm64_monterey: "efe95199dfdac81f2afeb10c31174417f5e1122dbafd96d1f4d9c1a9328efc82"
    sha256 cellar: :any,                 arm64_big_sur:  "5de7b6482b589a19b39c1034ca99e9c33fd12ad9506eaa487c47d933e99ee33d"
    sha256 cellar: :any,                 ventura:        "265414ed7d71f3ba2e0480c252111b00aad2777e9542fe1ece2dcf809d66260a"
    sha256 cellar: :any,                 monterey:       "4681e6416121e08c4b9bdabafd100237cc8cd6a94bd51f61a2efeaf54cc3ae0c"
    sha256 cellar: :any,                 big_sur:        "1843a10c467aed10f63521e6be0d15078437882e77cd076064f3744840615052"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d83a873b640bb8a7bf851b803b7e2d55c5e6bfd75336a8272d0e555cbfa14e7c"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "libfido2"

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  # Keep this in sync with https://github.com/gravitational/teleport/tree/v#{version}
  resource "webassets" do
    url "https://github.com/gravitational/webassets/archive/5f2597d5987804d37e61da8ae9d1a5a2d6b43ef4.tar.gz"
    sha256 "af70070a38b4cff5ab823670c11994989af5d3bccc5114b310936914b2d60703"
  end

  def install
    (buildpath/"webassets").install resource("webassets")
    ENV.deparallelize { system "make", "full", "FIDO2=dynamic" }
    bin.install Dir["build/*"]
  end

  test do
    curl_output = shell_output("curl \"https://api.github.com/repos/gravitational/teleport/contents/webassets?ref=v#{version}\"")
    assert_match JSON.parse(curl_output)["sha"], resource("webassets").url
    assert_match version.to_s, shell_output("#{bin}/teleport version")
    assert_match version.to_s, shell_output("#{bin}/tsh version")
    assert_match version.to_s, shell_output("#{bin}/tctl version")

    mkdir testpath/"data"
    (testpath/"config.yml").write <<~EOS
      version: v2
      teleport:
        nodename: testhost
        data_dir: #{testpath}/data
        log:
          output: stderr
          severity: WARN
    EOS

    fork do
      exec "#{bin}/teleport start --roles=proxy,node,auth --config=#{testpath}/config.yml"
    end

    sleep 10
    system "curl", "--insecure", "https://localhost:3080"

    status = shell_output("#{bin}/tctl --config=#{testpath}/config.yml status")
    assert_match(/Cluster\s*testhost/, status)
    assert_match(/Version\s*#{version}/, status)
  end
end
