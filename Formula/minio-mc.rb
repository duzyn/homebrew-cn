class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2022-12-13T00-23-28Z",
      revision: "4b4cab0441f000db100c5b5d9329221181bf61f2"
  version "20221213002328"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/mc.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/(?:RELEASE[._-]?)?([\dTZ-]+)["' >]}i)
    strategy :github_latest do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub(/\D/, "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0bfbe258031585f3652bd621dcffe2aa6f443f4e121fd4d4c8945ac81b29176b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf379ae5d2cfcfb74169ae6f36ab2108e9ad49f88252b1db227213cd5aef7421"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4837a1f4f8d7bc9db53cb3bdf78454aaf13bc6ce8ceb66636474169d3d950a84"
    sha256 cellar: :any_skip_relocation, ventura:        "cc54b32d4303966f15b106f2a8e2d31e2713f7de9e37ecd22155386259e3b964"
    sha256 cellar: :any_skip_relocation, monterey:       "50376d023e90d0c49d7bc1dc55b5d12dc359d1be80ab8290805c967c89df2362"
    sha256 cellar: :any_skip_relocation, big_sur:        "7b8e1775d5f4a0733535e5814b7e7b3326c98b9ab3b6bcf635f54b4a6c320f35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9304e3ae0da3cd9a95b9e94e1e12bae31bfa8fe9d665c64423c94cf5d2596e19"
  end

  depends_on "go" => :build

  conflicts_with "midnight-commander", because: "both install an `mc` binary"

  def install
    if build.head?
      system "go", "build", *std_go_args(output: bin/"mc")
    else
      minio_release = stable.specs[:tag]
      minio_version = minio_release.gsub(/RELEASE\./, "").chomp.gsub(/T(\d+)-(\d+)-(\d+)Z/, 'T\1:\2:\3Z')
      proj = "github.com/minio/mc"
      ldflags = %W[
        -X #{proj}/cmd.Version=#{minio_version}
        -X #{proj}/cmd.ReleaseTag=#{minio_release}
        -X #{proj}/cmd.CommitID=#{Utils.git_head}
      ]
      system "go", "build", *std_go_args(output: bin/"mc", ldflags: ldflags)
    end
  end

  test do
    system bin/"mc", "mb", testpath/"test"
    assert_predicate testpath/"test", :exist?
  end
end
