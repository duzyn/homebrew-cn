class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v15.7.1",
      revision: "6d4809485d18a643e97eea1a158f87ed124c23d5"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "101f6e51499638c343b685e49430b63d675e8eafe248eb122809fe8cc7a145d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67222bf3fbd5c504392e94c68e85f3e9469885d5f3410abf8ef4dba63480073f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "264f47f2c0ef1bb198b7d0fd7e204d0bfde743fe65b4a61f86c2c5ee36cf3631"
    sha256 cellar: :any_skip_relocation, ventura:        "b0cf1b038cc9bbc82cb04aae899a1c4e98696002994c7bab6fe8e7648de91888"
    sha256 cellar: :any_skip_relocation, monterey:       "e26aec7ab7c53aacc18a61a468e7401439db6bec080bd7869807573b49b35bc0"
    sha256 cellar: :any_skip_relocation, big_sur:        "1f81337ebfd321d8599159b64077c82da0155d130a9807f916b3a2bfc335bd97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7592df05fe73650845ab267633ce0e35ad5e2eac429a64c8f4f628b04358ded"
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
