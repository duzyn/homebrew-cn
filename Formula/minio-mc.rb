class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2022-12-24T15-21-38Z",
      revision: "176072dee43de613569aaa56061eba9d6d550290"
  version "20221224152138"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc6bfe4474ae2ea6843d4a367a0965fec57bfc46d963c8de9641267e8f3739d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2bd86eeef1f014ed56a5f4d9e52758786ca356331cf3e5a22af214b020eda77"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e252fbbaf8286eb53d107ed99e4a4acb2ca5193c2e74729e47a08ee783bc9424"
    sha256 cellar: :any_skip_relocation, ventura:        "ba572dde442c7004f3f9f5e311db3f46f2124726f4fe01bb2998b6195fb435fb"
    sha256 cellar: :any_skip_relocation, monterey:       "bb3430be7ddb33710f4b36fb06b878e066b888d93ab436b3ba5eab78fa28d954"
    sha256 cellar: :any_skip_relocation, big_sur:        "2bea994e4674032242175a8653420c1324caadb13fb36bab44ab729ba85dd118"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47aee1ab632b012d50c796633c019f2ab2a9377c391046d2968c71224c4aaa44"
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
