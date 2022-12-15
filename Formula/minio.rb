class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-12-12T19-27-27Z",
      revision: "a469e6768df4d5d2cb340749fa58e4721a7dee96"
  version "20221212192727"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d26f5ecb7ae94c07e832384192a146466fdb038d4a1186d7245d0bd3a88e0789"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "404e22de926f8346d95c7fb9ee5385f5994c44538077e21caa846253a62f40d4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f72665ae42b4fd6c11742cbaa5a8475074d6893853eb49c7c95f88021b939caa"
    sha256 cellar: :any_skip_relocation, ventura:        "d38e75a06ae7d6c7adafae024d8bab3c3064f397e5cc07c3e29b70b99ac02bf9"
    sha256 cellar: :any_skip_relocation, monterey:       "489d9225e0bec76219cf64b19d5f1c4d8d25c68304ed1972f762af98ba355ebf"
    sha256 cellar: :any_skip_relocation, big_sur:        "6611e1c4eedd2f7ce75b22a84ca22bcece061a61b58ec24465120586482832d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "593c6ed4aa0e09be6d3e9f9674f4dcc91ca8b984cb4c22c42ebed4d4455c564e"
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
