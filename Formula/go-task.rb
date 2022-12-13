class GoTask < Formula
  desc "Task is a task runner/build tool that aims to be simpler and easier to use"
  homepage "https://taskfile.dev/"
  url "https://github.com/go-task/task/archive/refs/tags/v3.19.0.tar.gz"
  sha256 "250a788958f306a11a4e8a621635d4f752478e4396c6a222a8f6ea640a220bff"
  license "MIT"
  head "https://github.com/go-task/task.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bbc7ae7ffc2abdc9bd36a98e7ab05198f2bed768f33975399880ef9265a3bede"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9bee842416a16399d023ce8a8da4b7714a70a72cac6834627966e7d3dc2b891e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5fa9d60db144b938708f5c33c6c5d529bc9e396e3e0bb9caf9e1407b29714629"
    sha256 cellar: :any_skip_relocation, ventura:        "33dc62af7558f1fced1b1d6e06ac196c5087adba67127d5061054b84c466720f"
    sha256 cellar: :any_skip_relocation, monterey:       "8b14723228e1c46d75e9d0171418f0dd36b4988e4171bb9830f3c485b19bdca0"
    sha256 cellar: :any_skip_relocation, big_sur:        "e7026863c5efa1d606e64dc3ac3c21b09c7b867f6b87834469fe1dd68008ad5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6561e39fce5f71bb12421714e72e43334cacbed1f74ed4b283fffc8e161de9c7"
  end

  depends_on "go" => :build

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
