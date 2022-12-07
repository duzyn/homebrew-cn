class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v11.1.2.tar.gz"
  sha256 "e9cda9f7a985a581c4e9197ea92cf525d7a2f74570ade5b19bb7d7a61d563c52"
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
    sha256 cellar: :any,                 arm64_ventura:  "5af678508187ec1d92ea8815fb37628c16e02da347c0f9a5a185dda466e3252a"
    sha256 cellar: :any,                 arm64_monterey: "8ed99cfe15db3fe6a2c2317e914dbbea99532d4b3c6cf1753076842874c8f064"
    sha256 cellar: :any,                 arm64_big_sur:  "6692e2758b3dfd9a1965e2f4d3de1d2a60097f5fa0eef6d4ccf5928472972056"
    sha256 cellar: :any,                 ventura:        "4c9659bcbcabb78b05b7214b3a50c26f5a85516bc3faa3df8a3d458edbfbcbf6"
    sha256 cellar: :any,                 monterey:       "e3e5c351ee65a2773f060bcc3eae0b0c8edae10ab1e5b48ca9edb08a09bfe5fb"
    sha256 cellar: :any,                 big_sur:        "aada50a2e016d2cefe27cf25a838f5f1eb84f4fb40976e5d03f49795f9561e4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8aa8699d165d49f3d85f8506f602a69477992a574f9d479883de0df1d32f819"
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
    url "https://github.com/gravitational/webassets/archive/56c3ba009a689f0119cadd9f832f4db7c0647ba4.tar.gz"
    sha256 "f98e1f0ab8e0d6d4a252afd8a52188f6fddb2afbf4ed29553c0e39c88e976003"
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
