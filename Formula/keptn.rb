class Keptn < Formula
  desc "CLI for keptn.sh, a message-driven control-plane for application delivery"
  homepage "https://keptn.sh"
  url "https://github.com/keptn/keptn/archive/1.0.0.tar.gz"
  sha256 "b6275c98cbba289de3105799d0cd7f60702a4bc6af4fa096302287e6a9f16aaf"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "73cf0014fd3543c4eb9776e110ed998c888e1b4be406e9bc3b8737add5094da9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e1110615bce2c836b2fd3e7d518d18a0a93937da06a6104f481e3d2689b0f8e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b624f6f267b9ec9415a7bda1db6769f1c6bf8efc57e0f301946eec3c30b66ab9"
    sha256 cellar: :any_skip_relocation, ventura:        "4985b6ba670f7771f29f2d6f8c412130d85c7fdd9266ff9f6deb23c8852ebc4f"
    sha256 cellar: :any_skip_relocation, monterey:       "587a5a4d57119b310b9aeb45fa8bd54824be9cf338759857325a729de0a10d8d"
    sha256 cellar: :any_skip_relocation, big_sur:        "94d93d320a6f97d3faa22027b502df67378d111bb8a968ebfd72b9f7d83f4a3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff8e2806b1f0374eda5eaa94576a820dde804d35b199e7dcaa2ff8ca0aa55543"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/keptn/keptn/cli/cmd.Version=#{version}
      -X main.KubeServerVersionConstraints=""
    ]

    cd buildpath/"cli" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end
  end

  test do
    system bin/"keptn", "set", "config", "AutomaticVersionCheck", "false"
    system bin/"keptn", "set", "config", "kubeContextCheck", "false"

    assert_match "Keptn CLI version: #{version}", shell_output(bin/"keptn version 2>&1")

    output = shell_output(bin/"keptn status 2>&1", 1)
    if OS.mac?
      assert_match "Error: credentials not found in native keychain", output
    else
      assert_match ".keptn/.keptn____keptn: no such file or directory", output
    end
  end
end
