class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v11.1.0.tar.gz"
  sha256 "c2d6de3349c88a82a489e361c55133fde911ebd3a89a9a1e83c6414d5825f960"
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
    sha256 cellar: :any,                 arm64_ventura:  "06e2c4d8ff14c82d8015db91f4382c043ce5f26ac47f16e8b06b2ffd6c90a2b6"
    sha256 cellar: :any,                 arm64_monterey: "1dd3f17932e1922f12b723994039700c2da6aa90cb6b69721b787383549af4a8"
    sha256 cellar: :any,                 arm64_big_sur:  "e1ca48f935c1bbc4c646ace9038f3f449ec2d151538343064583aec3ed301697"
    sha256 cellar: :any,                 ventura:        "fc0f78eda6ce819eefb47baf4086295657f3a4f44fc782f06fff264ca4c661f3"
    sha256 cellar: :any,                 monterey:       "61542a7b69386e27cf55929f0c5e2202b90cfccac32cea4a010996370bdf2919"
    sha256 cellar: :any,                 big_sur:        "fb3461804a4ac36fd792d2ea93df4d82bdcb02e3ef26747534d333f9c825baa7"
    sha256 cellar: :any,                 catalina:       "c0a7c062c72680e586a1a36751d5192207cb3fef3e74ea36f670d90e056b12dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72520213cd9c650a6dc42523c346571326401a11c9c7405793d47ffb3d04f57c"
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
    url "https://github.com/gravitational/webassets/archive/b2910b3430edd76b69e76a896fe594cc6082a66c.tar.gz"
    sha256 "3f444a568e1ea1c1385b286d6647d4b6fb023c3ddd99ee277b8799757d3f20f1"
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
