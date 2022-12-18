class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v15.7.0",
      revision: "259d2fd4e015d0e6acabe416362371ea0b40730a"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e1508e0b67059e65e09bb2b45bbc493b7bb47cc8d378a62dad0be665e8b36fd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f41d6382d447eec6c16f9461b5472d2f8785a0655e61f37b80e42552cecb9751"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "be581631a0d7975024a902dbbfd3d0995a2f421d0f194d21adf2d0f4cde74d71"
    sha256 cellar: :any_skip_relocation, ventura:        "52daf044b1aa6e65df694b8ab4428bf39854d1cb8b7cf4dd8e617851f2d56e57"
    sha256 cellar: :any_skip_relocation, monterey:       "884c2343718c4578f66ee59611a7838fe8904ca389b50cbfa9d1bec70a56d058"
    sha256 cellar: :any_skip_relocation, big_sur:        "8e8d568bc8dd79591190a5ce8608c977741db696040aa26b4cea8ce898eb843f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2c815ff021f5b5335fe87c9d91a8962255b26b3f0680e1208b6455d431acf86"
  end

  depends_on "go" => :build

  def install
    proj = "gitlab.com/gitlab-org/gitlab-runner"
    ldflags = %W[
      -X #{proj}/common.NAME=gitlab-runner
      -X #{proj}/common.VERSION=#{version}
      -X #{proj}/common.REVISION=#{Utils.git_short_head(length: 8)}
      -X #{proj}/common.BRANCH=#{version.major}-#{version.minor}-stable
      -X #{proj}/common.BUILT=#{time.strftime("%Y-%m-%dT%H:%M:%S%:z")}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  service do
    run [opt_bin/"gitlab-runner", "run", "--syslog"]
    environment_variables PATH: std_service_path_env
    working_dir Dir.home
    keep_alive true
    macos_legacy_timers true
    process_type :interactive
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitlab-runner --version")
  end
end
