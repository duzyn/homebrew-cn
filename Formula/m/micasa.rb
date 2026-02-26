class Micasa < Formula
  desc "TUI for tracking home projects, maintenance schedules, appliances and quotes"
  homepage "https://micasa.dev"
  url "https://mirror.ghproxy.com/https://github.com/cpcloud/micasa/archive/refs/tags/v1.52.0.tar.gz"
  sha256 "86e937eaecdb0cd44285ef05fb7af256e563489e830ecc826ea7dd234a893cd0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "685544a2ce22c7163d56cd95813064007cc1872bead0d8e38cd7c6daa7158f5c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "685544a2ce22c7163d56cd95813064007cc1872bead0d8e38cd7c6daa7158f5c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "685544a2ce22c7163d56cd95813064007cc1872bead0d8e38cd7c6daa7158f5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "10635bab8eff387a2197ecb1c2ba81260d91c7c137dc4528335ec16562c94706"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e75085644dfbd3e7e2075d8579fadd24a7e9e306aa1d46cfe6f2b71ac9c52667"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3697a9e9a4cca46929cbdc410a205e828e9666e48739034d1f7bf248e949faed"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/micasa"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/micasa --version")

    # The program is a TUI so we need to spawn it and close the process after it creates the database file.
    pid = spawn(bin/"micasa", "--demo", testpath/"demo.db")
    sleep 3
    Process.kill("TERM", pid)
    Process.wait(pid)

    assert_path_exists testpath/"demo.db"
  end
end
