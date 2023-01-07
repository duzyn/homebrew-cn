class GoTask < Formula
  desc "Task is a task runner/build tool that aims to be simpler and easier to use"
  homepage "https://taskfile.dev/"
  url "https://github.com/go-task/task/archive/refs/tags/v3.19.1.tar.gz"
  sha256 "b4f6021777f87f261a5646c0092e1b7d6dd252c4fc84ded015b89e0dae59383d"
  license "MIT"
  head "https://github.com/go-task/task.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd4dcca80a5be220e942fa67361cbdaf3e78e7b05f91d0cfe3ca5e7bd5efb020"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f35cea3b9f910c47c305adf17addddc82e4ee853193479d83fb93ebf3d562b28"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "955a7dec15f39a697c67dadd95acfdd394915015fe8a004b4044a99402f0f3e5"
    sha256 cellar: :any_skip_relocation, ventura:        "5bea8d432d54894d5660b30a6ce2068f191e1040807dcf3cdaeee2f090cd446a"
    sha256 cellar: :any_skip_relocation, monterey:       "e028880e831747508a9d3d040545e77bc857b94e7050445c6842a54bf8479637"
    sha256 cellar: :any_skip_relocation, big_sur:        "d0cfa544c8e9d0442e702a208cc4624636f1e49ddc12c1d764d14d2fbe384830"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58aede0ef072489959ed3c65cc1b8ae5b681da9aed7e7d75e35bcd6d76de9eef"
  end

  depends_on "go" => :build
  conflicts_with "task", because: "both install `task` binaries"

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"task"), "./cmd/task"
    bash_completion.install "completion/bash/task.bash" => "task"
    zsh_completion.install "completion/zsh/_task" => "_task"
    fish_completion.install "completion/fish/task.fish"
  end

  test do
    str_version = shell_output("#{bin}/task --version")
    assert_match "Task version: #{version}", str_version

    taskfile = testpath/"Taskfile.yml"
    taskfile.write <<~EOS
      version: '3'

      tasks:
        test:
          cmds:
            - echo 'Testing Taskfile'
    EOS

    args = %W[
      --taskfile #{taskfile}
      --silent
    ].join(" ")

    ok_test = shell_output("#{bin}/task #{args} test")
    assert_match "Testing Taskfile", ok_test
  end
end
