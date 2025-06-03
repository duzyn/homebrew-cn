class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://mirror.ghproxy.com/https://github.com/digitalocean/doctl/archive/refs/tags/v1.128.0.tar.gz"
  sha256 "bfbf129f0e9d0e00b4824edcb03107bfdccff87edb2802f66ae35ef5ed39906b"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c94d39a4ccb644843c001c50fc3181865372c038e836867680b7174bbf9ec0ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c94d39a4ccb644843c001c50fc3181865372c038e836867680b7174bbf9ec0ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c94d39a4ccb644843c001c50fc3181865372c038e836867680b7174bbf9ec0ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b0a24a2afd0997cffa5b433c8bdf85e17314d9ef52e5ae0f5c2fcd9a2de1e39"
    sha256 cellar: :any_skip_relocation, ventura:       "5b0a24a2afd0997cffa5b433c8bdf85e17314d9ef52e5ae0f5c2fcd9a2de1e39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acb2fbd1810cafd5ec59d116004b04f23460e89033fde0f9bd06b25e7abea303"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/digitalocean/doctl.Major=#{version.major}
      -X github.com/digitalocean/doctl.Minor=#{version.minor}
      -X github.com/digitalocean/doctl.Patch=#{version.patch}
      -X github.com/digitalocean/doctl.Label=release
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/doctl"

    generate_completions_from_executable(bin/"doctl", "completion")
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}/doctl version")
  end
end
