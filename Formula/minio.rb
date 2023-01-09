class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2023-01-06T18-11-18Z",
      revision: "ebd4388cca5e28619970032e32ddeb2cb51a6b38"
  version "20230106181118"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/minio.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/(?:RELEASE[._-]?)?([\dTZ-]+)["' >]}i)
    strategy :github_latest do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub(/\D/, "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "24ea79e2e1c4c3357de8943305f89a1a647847b4bb92e02bb5a401d41a51ca77"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "109f36762808bab316c4d5ac6658b3f1df279e166ed01e766f978785003aaccb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2272d4e4790a8aa013c2b1a804e85df7da0e33b125b4b8c81c83c2199642289f"
    sha256 cellar: :any_skip_relocation, ventura:        "0012d6b48c9a60f1f9bd6acbedc2180cf3358e929607a619f00c549724a02df2"
    sha256 cellar: :any_skip_relocation, monterey:       "16bd33caed9d6bc9d426f113806326548a034a4c44e070864b1943b14dbed049"
    sha256 cellar: :any_skip_relocation, big_sur:        "d7d44fdf87c474fda20c6d3cb3e4b904621d31d62e347e8e80b14c202f3b9b2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "520e011269ad96bc0b112490ed9e0d7e1e6f9b17b9dbfbe7df2ce29f849906f2"
  end

  depends_on "go" => :build

  def install
    if build.head?
      system "go", "build", *std_go_args
    else
      release = `git tag --points-at HEAD`.chomp
      version = release.gsub(/RELEASE\./, "").chomp.gsub(/T(\d+)-(\d+)-(\d+)Z/, 'T\1:\2:\3Z')

      ldflags = %W[
        -s -w
        -X github.com/minio/minio/cmd.Version=#{version}
        -X github.com/minio/minio/cmd.ReleaseTag=#{release}
        -X github.com/minio/minio/cmd.CommitID=#{Utils.git_head}
      ]

      system "go", "build", *std_go_args(ldflags: ldflags)
    end
  end

  def post_install
    (var/"minio").mkpath
    (etc/"minio").mkpath
  end

  service do
    run [opt_bin/"minio", "server", "--config-dir=#{etc}/minio", "--address=:9000", var/"minio"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/minio.log"
    error_log_path var/"log/minio.log"
  end

  test do
    assert_match "minio server - start object storage server",
      shell_output("#{bin}/minio server --help 2>&1")
  end
end
